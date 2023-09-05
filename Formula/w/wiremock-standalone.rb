class WiremockStandalone < Formula
  desc "Simulator for HTTP-based APIs"
  homepage "https://wiremock.org/docs/running-standalone/"
  url "https://search.maven.org/remotecontent?filepath=org/wiremock/wiremock-standalone/3.0.2/wiremock-standalone-3.0.2.jar"
  sha256 "d7f77f1b973222df99a7812f80d97e7290bb55565edac98845359b73401ab9b3"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/wiremock/wiremock-standalone/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "007ee2e6fc63507150cf8f661015ce23466362ee069e77f0e1b87d485ec3069d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "007ee2e6fc63507150cf8f661015ce23466362ee069e77f0e1b87d485ec3069d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "007ee2e6fc63507150cf8f661015ce23466362ee069e77f0e1b87d485ec3069d"
    sha256 cellar: :any_skip_relocation, ventura:        "007ee2e6fc63507150cf8f661015ce23466362ee069e77f0e1b87d485ec3069d"
    sha256 cellar: :any_skip_relocation, monterey:       "007ee2e6fc63507150cf8f661015ce23466362ee069e77f0e1b87d485ec3069d"
    sha256 cellar: :any_skip_relocation, big_sur:        "007ee2e6fc63507150cf8f661015ce23466362ee069e77f0e1b87d485ec3069d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbfeee6863d6fcbcdee6aa0dc857fee97fd9958dd6b41a83f582d79a2df96e2b"
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
