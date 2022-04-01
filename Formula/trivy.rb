class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://aquasecurity.github.io/trivy/"
  url "https://github.com/aquasecurity/trivy/archive/v0.25.0.tar.gz"
  sha256 "42c956ec41dad926437f099c983d24029713a18a3d3a26706f1db64df8f1dd20"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "510800c0ee69bfb0ba996af434fed8ad8ae6dee8dd8509a27392f710020dc5be"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0dc0407cbdb9c903b7002ec39a94a6aa5c845ad79f20b3662716d57443a62493"
    sha256 cellar: :any_skip_relocation, monterey:       "c748d51652cea8737817d1717c34ee253e2e9575625a12da21dd431d61f858c1"
    sha256 cellar: :any_skip_relocation, big_sur:        "d4bad70a9b11513068207d7de865c5b907b287609593b4af3b3380645f283a7f"
    sha256 cellar: :any_skip_relocation, catalina:       "2dc7abd0a511a87d4d397d9a8002597dd57dbbb861d7a0d442194914876f2d10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2e6ecdb3848f791e9dc6d15bf552e4be2edae48e8574a2011331e8b52548d62"
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
