class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://aquasecurity.github.io/trivy/"
  url "https://github.com/aquasecurity/trivy/archive/v0.29.0.tar.gz"
  sha256 "3e125b762cdf5ac9b8266c218648d975d1e91eb591c01d4c5e7dd32e5f665f27"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "159a6a7ab45078abea4a1ea1af401e27d3041fc777e5070c42a554ffdd5e863d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "002d28d1976d0c64516195e2a9dabdfd4169ca518b5111c1fc1a8f907e16f375"
    sha256 cellar: :any_skip_relocation, monterey:       "fcf4ef37b02f90f451f8a2d1a295a02490b1eaca7d5d3a9a51597064e7e4794a"
    sha256 cellar: :any_skip_relocation, big_sur:        "c44829babb4d20e1d05d01d278d66682b39da046a5308087659ea8c4b415a6ef"
    sha256 cellar: :any_skip_relocation, catalina:       "360b7f462236f3576386796374b4d6ad65049971fe5ae4115be257e3356e9b25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3616b660a4ae96948801ba1a50cf00659a7812f151a656761f7f546b0963b639"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X=main.version=#{version}"), "./cmd/trivy"
  end

  test do
    output = shell_output("#{bin}/trivy image alpine:3.10")
    assert_match(/\(UNKNOWN: \d+, LOW: \d+, MEDIUM: \d+, HIGH: \d+, CRITICAL: \d+\)/, output)

    assert_match version.to_s, shell_output("#{bin}/trivy --version")
  end
end
