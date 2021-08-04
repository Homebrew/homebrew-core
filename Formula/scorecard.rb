class Scorecard < Formula
  desc "Security health metrics for Open Source"
  homepage "https://github.com/ossf/scorecard"
  url "https://github.com/ossf/scorecard/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "9db79e73b7bccdc385d857bdab773b5cf10f70ca64c9828320b7e125a11c0222"
  license "Apache-2.0"
  head "https://github.com/ossf/scorecard.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a747fe3a71d3465f73216e7734072600efbbba57e6697090987c1760cf477a89"
    sha256 cellar: :any_skip_relocation, big_sur:       "df8bce028f6c950331399680a3b66e089935272f2425fd3ab259cef718416c81"
    sha256 cellar: :any_skip_relocation, catalina:      "565e522419b7f7e3da759c8d20da2213309fbd1cc43ceedfa7a8efa4f4a1f894"
    sha256 cellar: :any_skip_relocation, mojave:        "4320ab74ea78752e4c296147e1388b243f5d46640a2ed5efb174c7f6b8f4f478"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    cd("checks/main") { system "go", "run", "main.go" }
    doc.install "checks/checks.md"
  end

  test do
    ENV["GITHUB_AUTH_TOKEN"] = "test"
    output = shell_output("#{bin}/scorecard --repo=github.com/kubernetes/kubernetes --checks=Active 2>&1", 1)
    assert_match "GET https://api.github.com/repos/kubernetes/kubernetes: 401 Bad credentials", output
  end
end
