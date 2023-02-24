class Trino < Formula
  include Language::Python::Shebang

  desc "Distributed SQL query engine for big data"
  homepage "https://trino.io"
  url "https://search.maven.org/remotecontent?filepath=io/trino/trino-server/408/trino-server-408.tar.gz", using: :nounzip
  sha256 "e6edf64eaa7f8116af185eef9468ce93727ad258844d8676041272e427e3795e"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=io/trino/trino-server/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)*)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "427ff436b02a4dcfcea0fe83d11e46d5c2c65bc430e43ef57dcd0f3313663457"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "427ff436b02a4dcfcea0fe83d11e46d5c2c65bc430e43ef57dcd0f3313663457"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "427ff436b02a4dcfcea0fe83d11e46d5c2c65bc430e43ef57dcd0f3313663457"
    sha256 cellar: :any_skip_relocation, ventura:        "427ff436b02a4dcfcea0fe83d11e46d5c2c65bc430e43ef57dcd0f3313663457"
    sha256 cellar: :any_skip_relocation, monterey:       "427ff436b02a4dcfcea0fe83d11e46d5c2c65bc430e43ef57dcd0f3313663457"
    sha256 cellar: :any_skip_relocation, big_sur:        "427ff436b02a4dcfcea0fe83d11e46d5c2c65bc430e43ef57dcd0f3313663457"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ffa2bbcf5a179adf526525a9c760359729ec8102e0a83ebd1aac7ee52f0a70a"
  end

  depends_on "gnu-tar" => :build
  depends_on "openjdk"
  depends_on "python@3.11"

  resource "trino-src" do
    url "https://github.com/trinodb/trino/archive/refs/tags/407.tar.gz", using: :nounzip
    sha256 "e8a777efcab913ed80bd2a08ad18a5afaf9338e0ab15fc996edaa74f5863e11b"
  end

  resource "trino-cli" do
    url "https://search.maven.org/remotecontent?filepath=io/trino/trino-cli/407/trino-cli-407-executable.jar"
    sha256 "1b1fd386501758b7a392a4791e49da061614b2890d3bf76ecfa130aa56380912"
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
