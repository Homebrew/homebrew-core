class WiremockStandalone < Formula
  desc "Simulator for HTTP-based APIs"
  homepage "http://wiremock.org/docs/running-standalone/"
  url "https://search.maven.org/remotecontent?filepath=com/github/tomakehurst/wiremock-standalone/2.26.3/wiremock-standalone-2.26.3.jar"
  sha256 "de1f60e88565649a3a1c1a1e59f2ed58c2b5bd6417d91b6c77b93a5dd1bb3d77"
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
