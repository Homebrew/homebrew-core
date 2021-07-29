class WiremockStandalone < Formula
  desc "Simulator for HTTP-based APIs"
  homepage "http://wiremock.org/docs/running-standalone/"
  url "https://search.maven.org/remotecontent?filepath=com/github/tomakehurst/wiremock-jre8-standalone/2.29.1/wiremock-jre8-standalone-2.29.1.jar"
  sha256 "25d6f453863b4470f039cd44db37523ad4525217f684bbfa73f4cb8842a8dae1"
  license "Apache-2.0"
  head "https://github.com/tomakehurst/wiremock.git"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "646876162e46b2de6e0921016cf41a29113a1998e9094f510d6e788daec42b52"
  end

  depends_on "openjdk"

  def install
    libexec.install "wiremock-jre8-standalone-#{version}.jar"
    bin.write_jar_script libexec/"wiremock-jre8-standalone-#{version}.jar", "wiremock"
  end

  test do
    port = free_port

    wiremock = fork do
      exec "#{bin}/wiremock", "-port", port.to_s
    end

    loop do
      Utils.popen_read("curl", "-s", "http://localhost:#{port}/__admin/", "-X", "GET")
      break if $CHILD_STATUS.exitstatus.zero?
    end

    system "curl", "-s", "http://localhost:#{port}/__admin/shutdown", "-X", "POST"

    Process.wait(wiremock)
  end
end
