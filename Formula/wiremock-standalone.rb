class WiremockStandalone < Formula
  desc "Simulator for HTTP-based APIs"
  homepage "http://wiremock.org/docs/running-standalone/"
  url "https://search.maven.org/remotecontent?filepath=com/github/tomakehurst/wiremock-standalone/2.26.2/wiremock-standalone-2.26.2.jar"
  sha256 "daf68f08a3fbb143bb2bfa198903a04b9fa14dcaedc64639d48b50b49774803f"
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
