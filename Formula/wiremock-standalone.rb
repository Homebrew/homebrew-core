class WiremockStandalone < Formula
  desc "Simulator for HTTP-based APIs"
  homepage "http://wiremock.org/docs/running-standalone/"
  url "https://search.maven.org/remotecontent?filepath=com/github/tomakehurst/wiremock-standalone/2.27.1/wiremock-standalone-2.27.1.jar"
  sha256 "e98c07e202eb3f8b470b7d0ae2703c880736ac0de870bba31b231df9b9db7833"
  license "Apache-2.0"
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
