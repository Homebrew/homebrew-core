class WiremockStandalone < Formula
  desc "Simulator for HTTP-based APIs"
  homepage "http://wiremock.org/docs/running-standalone/"
  url "https://search.maven.org/remotecontent?filepath=com/github/tomakehurst/wiremock-standalone/2.24.1/wiremock-standalone-2.24.1.jar"
  sha256 "4220f785b912a0b39e7311e58292edde976e91b223d3784cd3c07184d65c5dac"
  head "https://github.com/tomakehurst/wiremock.git"

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    libexec.install "wiremock-standalone-#{version}.jar"
    bin.write_jar_script libexec/"wiremock-standalone-#{version}.jar", "wiremock"
  end

  test do
    require "socket"

    server = TCPServer.new(0)
    port = server.addr[1]
    server.close

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
