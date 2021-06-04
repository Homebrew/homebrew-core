class WiremockStandalone < Formula
  desc "Simulator for HTTP-based APIs"
  homepage "http://wiremock.org/docs/running-standalone/"
  url "https://search.maven.org/remotecontent?filepath=com/github/tomakehurst/wiremock-jre8-standalone/2.28.0/wiremock-jre8-standalone-2.28.0.jar"
  sha256 "d48710086f13108843976e0910f08114d5de65fb7274d8c34b55372a101e52b6"
  license "Apache-2.0"
  head "https://github.com/tomakehurst/wiremock.git"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2e38b720877972828202f5a362b9407ea2f861ee3c00a1b6ff0c1f964b756497"
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
