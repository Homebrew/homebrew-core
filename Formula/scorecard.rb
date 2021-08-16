class Scorecard < Formula
  desc "Security health metrics for Open Source"
  homepage "https://github.com/ossf/scorecard"
  url "https://github.com/ossf/scorecard/archive/refs/tags/v2.1.3.tar.gz"
  sha256 "d42dfc3e75272d95bf4c6ad81b56d406a1a5ee9c25d558a94255c9c89feb754e"
  license "Apache-2.0"
  head "https://github.com/ossf/scorecard.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8841bbb0b19f57d290cd71336d86085cea846a126b358cfd54e4ba050e4e485e"
    sha256 cellar: :any_skip_relocation, big_sur:       "e6df4dc6b6119a91d3025547226d1221c113dc3fc5f4b1822516c60cd4425335"
    sha256 cellar: :any_skip_relocation, catalina:      "b45a9deb9088c49751545a899f7d5149eb91373861d1559107b7c3d2da25ca84"
    sha256 cellar: :any_skip_relocation, mojave:        "cccbc97bb6291eff26cb219f1a6d14af334d8d1c3e43ad792742015e94aee4eb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    cd("docs/checks/generate") { system "go", "run", "main.go" }
    doc.install "docs/checks.md"
  end

  test do
    ENV["GITHUB_AUTH_TOKEN"] = "test"
    output = shell_output("#{bin}/scorecard --repo=github.com/kubernetes/kubernetes --checks=Active 2>&1", 1)
    assert_match "GET https://api.github.com/repos/kubernetes/kubernetes: 401 Bad credentials", output
  end
end
