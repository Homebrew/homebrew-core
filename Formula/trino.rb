class Trino < Formula
  include Language::Python::Shebang

  desc "Distributed SQL query engine for big data"
  homepage "https://trino.io"
  url "https://search.maven.org/remotecontent?filepath=io/trino/trino-server/374/trino-server-374.tar.gz"
  sha256 "e27d8c9a2f5125179530da6aa5ff3b067588e3880c958d8dc9a920f332cf4f06"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=io/trino/trino-server/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)*)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49aded566a752cdfe4402a440e0bf4d55fc924ac2f70190fbeccb85e8617e2e4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "49aded566a752cdfe4402a440e0bf4d55fc924ac2f70190fbeccb85e8617e2e4"
    sha256 cellar: :any_skip_relocation, monterey:       "49aded566a752cdfe4402a440e0bf4d55fc924ac2f70190fbeccb85e8617e2e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "49aded566a752cdfe4402a440e0bf4d55fc924ac2f70190fbeccb85e8617e2e4"
    sha256 cellar: :any_skip_relocation, catalina:       "49aded566a752cdfe4402a440e0bf4d55fc924ac2f70190fbeccb85e8617e2e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e64e0c8cb445c094fefbc90b90757d86b5bdfa4634bfcdb685c58f30f8908d82"
  end

  depends_on "gnu-tar" => :build
  depends_on "openjdk"
  depends_on "python@3.10"

  resource "trino-src" do
    url "https://github.com/trinodb/trino/archive/374.tar.gz", using: :nounzip
    sha256 "4bd7ef7017a867ec7b7f377e749f1914f2f44fc5d7b4bcc47c32ea4f013ddc7b"
  end

  resource "trino-cli" do
    url "https://search.maven.org/remotecontent?filepath=io/trino/trino-cli/374/trino-cli-374-executable.jar"
    sha256 "a872c2f38371cafee88e64ae0797bb69df7b0c95ee8b5316895749fe4bb995c4"
  end

  def install
    libexec.install Dir["*"]

    # Manually untar, since macOS-bundled tar produces the error:
    #   trino-363/plugin/trino-hive/src/test/resources/<truncated>.snappy.orc.crc: Failed to restore metadata
    # Remove when https://github.com/trinodb/trino/issues/8877 is fixed
    resource("trino-src").stage do |r|
      ENV.prepend_path "PATH", Formula["gnu-tar"].opt_libexec/"gnubin"
      system "tar", "-xzf", "trino-#{r.version}.tar.gz"
      (libexec/"etc").install Dir["trino-#{r.version}/core/docker/default/etc/*"]
      inreplace libexec/"etc/node.properties", "docker", tap.user.downcase
      inreplace libexec/"etc/node.properties", "/data/trino", var/"trino/data"
    end

    rewrite_shebang detected_python_shebang, libexec/"bin/launcher.py"
    (bin/"trino-server").write_env_script libexec/"bin/launcher", Language::Java.overridable_java_home_env

    resource("trino-cli").stage do
      libexec.install "trino-cli-#{version}-executable.jar"
      bin.write_jar_script libexec/"trino-cli-#{version}-executable.jar", "trino"
    end

    # Remove incompatible pre-built binaries
    libprocname_dirs = libexec.glob("bin/procname/*")
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
