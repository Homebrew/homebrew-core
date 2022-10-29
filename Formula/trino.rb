class Trino < Formula
  include Language::Python::Shebang

  desc "Distributed SQL query engine for big data"
  homepage "https://trino.io"
  url "https://search.maven.org/remotecontent?filepath=io/trino/trino-server/401/trino-server-401.tar.gz", using: :nounzip
  sha256 "8bdd83f023a91c181fe39530d5629e429826af2934169a5bc798adb4874a3836"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=io/trino/trino-server/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)*)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fd49875b814971b71c80d6b7a77ee662fafd4b14976a4ccf70810cca9c823f73"
  end

  depends_on "gnu-tar" => :build
  depends_on "openjdk"
  depends_on "python@3.10"

  resource "trino-src" do
    url "https://github.com/trinodb/trino/archive/refs/tags/401.tar.gz", using: :nounzip
    sha256 "753cbefe71ac4d42172625394239826c14cc3ffac477495032ddcb8a6ccc6581"
  end

  resource "trino-cli" do
    url "https://search.maven.org/remotecontent?filepath=io/trino/trino-cli/401/trino-cli-401-executable.jar"
    sha256 "d1ecbf67e82ca6e8672e1063da9e710d9ebdcc8533d531462b2f91bd0672d7e0"
  end

  def install
    # Manually extract tarball to avoid losing hardlinks which increases bottle
    # size from MBs to GBs. Remove once Homebrew is able to preserve hardlinks.
    # Ref: https://github.com/Homebrew/brew/pull/13154
    libexec.mkpath
    system "tar", "-C", libexec.to_s, "--strip-components", "1", "-xzf", "trino-server-#{version}.tar.gz"

    # Manually untar, since macOS-bundled tar produces the error:
    #   trino-363/plugin/trino-hive/src/test/resources/<truncated>.snappy.orc.crc: Failed to restore metadata
    # Remove when https://github.com/trinodb/trino/issues/8877 is fixed
    resource("trino-src").stage do |r|
      ENV.prepend_path "PATH", Formula["gnu-tar"].opt_libexec/"gnubin"
      system "tar", "-xzf", "trino-#{r.version}.tar.gz"
      (libexec/"etc").install Dir["trino-#{r.version}/core/docker/default/etc/*"]
      inreplace libexec/"etc/node.properties", "docker", tap.user.downcase
      inreplace libexec/"etc/node.properties", "/data/trino", var/"trino/data"
      inreplace libexec/"etc/jvm.config", %r{^-agentpath:/usr/lib/trino/bin/libjvmkill.so$\n}, ""
    end

    rewrite_shebang detected_python_shebang, libexec/"bin/launcher.py"
    (bin/"trino-server").write_env_script libexec/"bin/launcher", Language::Java.overridable_java_home_env

    resource("trino-cli").stage do
      libexec.install "trino-cli-#{version}-executable.jar"
      bin.write_jar_script libexec/"trino-cli-#{version}-executable.jar", "trino"
    end

    # Remove incompatible pre-built binaries
    libprocname_dirs = libexec.glob("bin/procname/*")
    # Keep the Linux-x86_64 directory to make bottles identical
    libprocname_dirs.reject! { |dir| dir.basename.to_s == "Linux-x86_64" } if build.bottle?
    libprocname_dirs.reject! { |dir| dir.basename.to_s == "#{OS.kernel_name}-#{Hardware::CPU.arch}" }
    libprocname_dirs.map(&:rmtree)
  end

  def post_install
    (var/"trino/data").mkpath
  end

  service do
    run [opt_bin/"trino-server", "run"]
    working_dir opt_libexec
  end

  test do
    port = free_port
    cp libexec/"etc/config.properties", testpath/"config.properties"
    inreplace testpath/"config.properties", "8080", port.to_s
    server = fork do
      exec bin/"trino-server", "run", "--verbose",
                                      "--data-dir", testpath,
                                      "--config", testpath/"config.properties"
    end
    sleep 30

    query = "SELECT state FROM system.runtime.nodes"
    output = shell_output(bin/"trino --debug --server localhost:#{port} --execute '#{query}'")
    assert_match "\"active\"", output
  ensure
    Process.kill("TERM", server)
    Process.wait server
  end
end
