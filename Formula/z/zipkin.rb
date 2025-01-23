class Zipkin < Formula
  desc "Collect and visualize traces written in Zipkin format"
  homepage "https://zipkin.io"
  url "https://search.maven.org/remotecontent?filepath=io/zipkin/zipkin-server/3.4.4/zipkin-server-3.4.4-exec.jar"
  sha256 "45530b0d895d7b56fffa5f6385f4bd45a6b8aa3c57e1c2bda4b4bb1225881333"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=io/zipkin/zipkin-server/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5bdb64f78113ea79378ac78cb644558059767d8bc267709a7a9fd6ecae71702d"
  end

  depends_on "openjdk"

  def install
    (libexec/"bin").install "zipkin-server-#{version}-exec.jar"
    bin.write_jar_script libexec/"bin/zipkin-server-#{version}-exec.jar", "zipkin"
  end

  service do
    run opt_bin/"zipkin"
    keep_alive true
    log_path var/"log/zipkin.log"
    error_log_path var/"log/zipkin.log"
  end

  test do
    port = free_port
    ENV["QUERY_PORT"] = port.to_s

    spawn bin/"zipkin"
    sleep 20
    assert_match "UP", shell_output("curl -s 127.0.0.1:#{port}/health")
  end
end
