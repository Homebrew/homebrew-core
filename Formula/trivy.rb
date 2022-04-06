class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://aquasecurity.github.io/trivy/"
  url "https://github.com/aquasecurity/trivy/archive/v0.25.3.tar.gz"
  sha256 "b052f1767499ba0d24220e68ada387cef4bb22cef18ef051185f18ee4347252c"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5fc09833f16a0099ff921f31cb6e9d427f833338c963592debb6931337764a0b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "93ecbca6eff9867450cc8b89ea835fa8295f0c0ed5a110be5dcb1886599315e2"
    sha256 cellar: :any_skip_relocation, monterey:       "1739f937d92f8f9777da03f6a4518710c154bb2326020af244572d617586ccc5"
    sha256 cellar: :any_skip_relocation, big_sur:        "30641bfa1e5b8d271559c4474e46b8684db410a41244a9d0450310eb8a7f1ced"
    sha256 cellar: :any_skip_relocation, catalina:       "16be75e8e24c51dffc2fe7e79968b11d499dad7b2e229ff630f80562a8c2996e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "881786e5351f61cc2b7b0711ea0e933daedeb0f3a66168fa307189fb45b426d6"
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
