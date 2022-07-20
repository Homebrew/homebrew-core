class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://aquasecurity.github.io/trivy/"
  url "https://github.com/aquasecurity/trivy/archive/v0.30.1.tar.gz"
  sha256 "cc7f775c1b965ec81595332b661b7acdd11ab5c994f8dd84f6b4328a946d7aab"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17819b3dd073b058dd6199a19e7c32c19bbabd03b99362aa9f262e841fe42710"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "25ea7960b8011204c330d32a4b932671db55c217c44b62e6b021328b2a54e76d"
    sha256 cellar: :any_skip_relocation, monterey:       "d2a6339fe03cf7eb0ffa9ef1c825ed0ac6d2b833758de5e57b758fe488dec4f1"
    sha256 cellar: :any_skip_relocation, big_sur:        "73de83cecb787ea211e7081427707ffa4aaaf15f9c37fd1e3a6fd840312f1ad1"
    sha256 cellar: :any_skip_relocation, catalina:       "8caa39d9a7fb449f2e982c346e0aedf94507159cc5f9b76288de37a53d7baf08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8666d48847943cbe3f66f1e71ff2318e348a9cd221fab55496869602598b9120"
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
