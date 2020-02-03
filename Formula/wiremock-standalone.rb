class WiremockStandalone < Formula
  desc "Simulator for HTTP-based APIs"
  homepage "http://wiremock.org/docs/running-standalone/"
  url "https://search.maven.org/remotecontent?filepath=com/github/tomakehurst/wiremock-standalone/2.26.0/wiremock-standalone-2.26.0.jar"
  sha256 "2e700abcd02c29e835522a306584a0483d8e3ce6a93d2af1c0766c8d7702cb7b"
  revision 1
  head "https://github.com/tomakehurst/wiremock.git"

  bottle :unneeded

  depends_on "openjdk"

  def install
    libexec.install "wiremock-standalone-#{version}.jar"
    (bin/"wiremock").write <<~EOS
      #!/bin/bash
      exec "#{Formula["openjdk"].opt_bin}/java" -jar "#{libexec}/wiremock-standalone-#{version}.jar" "$@"
    EOS
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
