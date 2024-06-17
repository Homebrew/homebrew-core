class Zipkin < Formula
  desc "Collect and visualize traces written in Zipkin format"
  homepage "https://zipkin.io"
  url "https://search.maven.org/remotecontent?filepath=io/zipkin/zipkin-server/3.4.0/zipkin-server-3.4.0-exec.jar"
  sha256 "e0ac243a9c72fb5708056ca7176cdbd3d95fbec4edf7484655ce715f846a966a"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=io/zipkin/zipkin-server/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8c208b185986ba06547a78b39d62f1a1a2dc538353a8371de61ee9f9997a90df"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a12cf552110ebc9296d4dcd086e6f8ac4409e08e465c6fe708c26d56dba3740a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d741230f247084ce90990bbeba5a5c511cf6ae8be4a0222510f6d6fc13aac829"
    sha256 cellar: :any_skip_relocation, sonoma:         "881752e9100eb47f70a3364aa047e036a5ecf8bf5a0ba37d76941acee41306e6"
    sha256 cellar: :any_skip_relocation, ventura:        "9d404a9ecd652deaec867ac10dd8ffc1ea52cd13afcc67d298a5defc4b01430e"
    sha256 cellar: :any_skip_relocation, monterey:       "286ef6a2d22f579b51a9f116bf82ca874f1a83c06ff8323acd19f211950a7211"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff9ec65ba45998328bbf70c3abbe934d2e3c24cc5f4908dd99c14eb9ef7f6cc1"
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

    fork do
      exec bin/"zipkin"
    end
    sleep 20
    assert_match "UP", shell_output("curl -s 127.0.0.1:#{port}/health")
  end
end
