class Trino < Formula
  desc "Distributed SQL query engine for big data"
  homepage "https://trino.io"
  url "https://search.maven.org/remotecontent?filepath=io/trino/trino-server/366/trino-server-366.tar.gz"
  sha256 "4eb490bdb35cec70eeba0921187ee599bbeea152f2c70973523b8d688cdbd0ad"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=io/trino/trino-server/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)*)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0abd555023f06d94a1b15007cf1e15605190e491a878af49a24da8c184d6415d"
  end

  depends_on "gnu-tar" => :build
  depends_on arch: :x86_64
  depends_on :macos # test fails on Linux
  depends_on "openjdk"

  resource "trino-src" do
    url "https://github.com/trinodb/trino/archive/366.tar.gz", using: :nounzip
    sha256 "c5f631ffbd1ab78bf54f75bf0bd83c64a6ed29f0e4dc77435704811a17bd663d"
  end

  resource "trino-cli" do
    url "https://search.maven.org/remotecontent?filepath=io/trino/trino-cli/366/trino-cli-366-executable.jar"
    sha256 "b976f04ce3e0ad14f5cc00817da5bed2faae295aa112e40e9d91edf76a66b5f7"
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
