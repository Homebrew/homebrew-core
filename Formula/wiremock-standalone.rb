class WiremockStandalone < Formula
  desc "Simulator for HTTP-based APIs"
  homepage "http://wiremock.org"
  url "https://search.maven.org/remotecontent?filepath=com/github/tomakehurst/wiremock-standalone/2.14.0/wiremock-standalone-2.14.0.jar"
  sha256 "538a8f04afbca02be70ea2fdb4d0680694a577d89abf114dd4f89ac44ed99f96"

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    libexec.install "wiremock-standalone-#{version}.jar"
    bin.write_jar_script libexec/"wiremock-standalone-#{version}.jar", "wiremock"
  end

  test do
    system "#{bin}/wiremock", "--help"
  end
end
