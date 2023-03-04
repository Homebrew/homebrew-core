class Trino < Formula
  include Language::Python::Shebang

  desc "Distributed SQL query engine for big data"
  homepage "https://trino.io"
  url "https://search.maven.org/remotecontent?filepath=io/trino/trino-server/409/trino-server-409.tar.gz", using: :nounzip
  sha256 "6b84435eba780ee6e7bd8d34750214d966bc22481453c4e844b79daa581f6fd5"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=io/trino/trino-server/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)*)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2fa138f7c05c15f053a645f2e1bd9cc8eeaa28ac1bd1c41689c20ad6871087b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2fa138f7c05c15f053a645f2e1bd9cc8eeaa28ac1bd1c41689c20ad6871087b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2fa138f7c05c15f053a645f2e1bd9cc8eeaa28ac1bd1c41689c20ad6871087b5"
    sha256 cellar: :any_skip_relocation, ventura:        "2fa138f7c05c15f053a645f2e1bd9cc8eeaa28ac1bd1c41689c20ad6871087b5"
    sha256 cellar: :any_skip_relocation, monterey:       "2fa138f7c05c15f053a645f2e1bd9cc8eeaa28ac1bd1c41689c20ad6871087b5"
    sha256 cellar: :any_skip_relocation, big_sur:        "2fa138f7c05c15f053a645f2e1bd9cc8eeaa28ac1bd1c41689c20ad6871087b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bef171dd81640d204302ca119d7a3776f9329ac5d9582fb96bb2f6fdc5cb8d3b"
  end

  depends_on "gnu-tar" => :build
  depends_on "openjdk"
  depends_on "python@3.11"

  resource "trino-src" do
    url "https://github.com/trinodb/trino/archive/refs/tags/408.tar.gz", using: :nounzip
    sha256 "0b0e826e35e95cb1bf7236defa8cccae88b8c29baa10aae282066107183749e2"
  end

  resource "trino-cli" do
    url "https://search.maven.org/remotecontent?filepath=io/trino/trino-cli/408/trino-cli-408-executable.jar"
    sha256 "831194215e52a301891b32527f23865fb3c27081badb208553ef06adc2cf33be"
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
