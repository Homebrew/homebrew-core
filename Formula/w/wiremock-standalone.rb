class WiremockStandalone < Formula
  desc "Simulator for HTTP-based APIs"
  homepage "https://wiremock.org/docs/running-standalone/"
  url "https://search.maven.org/remotecontent?filepath=org/wiremock/wiremock-standalone/3.0.1/wiremock-standalone-3.0.1.jar"
  sha256 "1602d2335f6556838d3a3341266cb3ef81850548ff4cd941750eaeb712a06525"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/wiremock/wiremock-standalone/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9d5dccb9ad443fe2000ed9a5aecba8a696976f9a33ba7afad04e0943f2a8de9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9d5dccb9ad443fe2000ed9a5aecba8a696976f9a33ba7afad04e0943f2a8de9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e9d5dccb9ad443fe2000ed9a5aecba8a696976f9a33ba7afad04e0943f2a8de9"
    sha256 cellar: :any_skip_relocation, ventura:        "e9d5dccb9ad443fe2000ed9a5aecba8a696976f9a33ba7afad04e0943f2a8de9"
    sha256 cellar: :any_skip_relocation, monterey:       "e9d5dccb9ad443fe2000ed9a5aecba8a696976f9a33ba7afad04e0943f2a8de9"
    sha256 cellar: :any_skip_relocation, big_sur:        "e9d5dccb9ad443fe2000ed9a5aecba8a696976f9a33ba7afad04e0943f2a8de9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26c5f72a87baee8386745179cd47a46f05d348311196ad763efe0368f057a5a0"
  end

  depends_on "openjdk"

  def install
    libexec.install "wiremock-standalone-#{version}.jar"
    bin.write_jar_script libexec/"wiremock-standalone-#{version}.jar", "wiremock"
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
