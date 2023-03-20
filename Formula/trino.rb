class Trino < Formula
  include Language::Python::Shebang

  desc "Distributed SQL query engine for big data"
  homepage "https://trino.io"
  url "https://search.maven.org/remotecontent?filepath=io/trino/trino-server/410/trino-server-410.tar.gz", using: :nounzip
  sha256 "ed41b65ba8e054510bb45ca09084831460a01c232d320cf9d8fdb7ed093adf33"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=io/trino/trino-server/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)*)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d7ff777253b9f767b478263910b8252b5810e61e989963a8a7a70be68616ea6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d7ff777253b9f767b478263910b8252b5810e61e989963a8a7a70be68616ea6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8d7ff777253b9f767b478263910b8252b5810e61e989963a8a7a70be68616ea6"
    sha256 cellar: :any_skip_relocation, ventura:        "8d7ff777253b9f767b478263910b8252b5810e61e989963a8a7a70be68616ea6"
    sha256 cellar: :any_skip_relocation, monterey:       "8d7ff777253b9f767b478263910b8252b5810e61e989963a8a7a70be68616ea6"
    sha256 cellar: :any_skip_relocation, big_sur:        "8d7ff777253b9f767b478263910b8252b5810e61e989963a8a7a70be68616ea6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb06ea5cb5b6a360bfcc6532f71b6e2d9f4d73719d6297e5f9873b304df2998b"
  end

  depends_on "gnu-tar" => :build
  depends_on "openjdk"
  depends_on "python@3.11"

  resource "trino-src" do
    url "https://github.com/trinodb/trino/archive/refs/tags/410.tar.gz", using: :nounzip
    sha256 "ccd3636031d67b86896a9192127afd31bc25e1812c57501ac76c70bd3a6a04dd"
  end

  resource "trino-cli" do
    url "https://search.maven.org/remotecontent?filepath=io/trino/trino-cli/410/trino-cli-410-executable.jar"
    sha256 "f32c257b9cfc38e15e8c0b01292ae1f11bda2b23b5ce1b75332e108ca7bf2e9b"
  end

  def install
    # Manually extract tarball to avoid losing hardlinks which increases bottle
    # size from MBs to GBs. Remove once Homebrew is able to preserve hardlinks.
    libexec.mkpath
    system "tar", "-C", libexec.to_s, "--strip-components", "1", "-xzf", "trino-server-#{version}.tar.gz"

    # Manually untar, since macOS-bundled tar produces the error:
    #   trino-363/plugin/trino-hive/src/test/resources/<truncated>.snappy.orc.crc: Failed to restore metadata
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
