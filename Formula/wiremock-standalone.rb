class WiremockStandalone < Formula
  desc "Simulator for HTTP-based APIs"
  homepage "http://wiremock.org/docs/running-standalone/"
  url "https://search.maven.org/remotecontent?filepath=com/github/tomakehurst/wiremock-jre8-standalone/2.29.0/wiremock-jre8-standalone-2.29.0.jar"
  sha256 "74304822f8b83e1a54fb2b8860c83599d5316e485187310faab6d770e8ca4c41"
  license "Apache-2.0"
  head "https://github.com/tomakehurst/wiremock.git"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7fcae75df4a3c2dcb76823c2ccd801de74fd6545dd10167a6cc9ce49940b45e4"
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
