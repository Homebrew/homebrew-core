class WiremockStandalone < Formula
  desc "Simulator for HTTP-based APIs"
  homepage "https://wiremock.org/docs/running-standalone/"
  url "https://search.maven.org/remotecontent?filepath=org/wiremock/wiremock-standalone/3.2.0/wiremock-standalone-3.2.0.jar"
  sha256 "be83bd500c61c509565ace233238bddd305409c15686dff809e6be5290662f74"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/wiremock/wiremock-standalone/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "83a7c8f364c54adae2d86e11585727bb90d1c5d987a553b5004c3d029f505f6a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "83a7c8f364c54adae2d86e11585727bb90d1c5d987a553b5004c3d029f505f6a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83a7c8f364c54adae2d86e11585727bb90d1c5d987a553b5004c3d029f505f6a"
    sha256 cellar: :any_skip_relocation, sonoma:         "83a7c8f364c54adae2d86e11585727bb90d1c5d987a553b5004c3d029f505f6a"
    sha256 cellar: :any_skip_relocation, ventura:        "83a7c8f364c54adae2d86e11585727bb90d1c5d987a553b5004c3d029f505f6a"
    sha256 cellar: :any_skip_relocation, monterey:       "83a7c8f364c54adae2d86e11585727bb90d1c5d987a553b5004c3d029f505f6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4ff5c2edef9d32ba6aee4de6bcb625df4a8a76443a048db96b46268a3943f09"
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
