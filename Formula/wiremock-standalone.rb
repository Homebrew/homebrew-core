class WiremockStandalone < Formula
  desc "Simulator for HTTP-based APIs"
  homepage "https://wiremock.org/docs/running-standalone/"
  url "https://search.maven.org/remotecontent?filepath=com/github/tomakehurst/wiremock-jre8-standalone/2.33.0/wiremock-jre8-standalone-2.33.0.jar"
  sha256 "f752eac625f716c83fe54a666ea8394c452d46ac1b28a2559425cd34bad39d33"
  license "Apache-2.0"
  head "https://github.com/tomakehurst/wiremock.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6c7c7c2361e2bb4a012cea8064df7ac283d1043a0a2d5c32742f0b8724923f9e"
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
