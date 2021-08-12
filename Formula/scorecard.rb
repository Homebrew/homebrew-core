class Scorecard < Formula
  desc "Security health metrics for Open Source"
  homepage "https://github.com/ossf/scorecard"
  url "https://github.com/ossf/scorecard/archive/refs/tags/v2.1.2.tar.gz"
  sha256 "74cce8c0f27a1d5c473172c89e86ab90b290c016b2b7dae7c99dbf65f9d0fb03"
  license "Apache-2.0"
  head "https://github.com/ossf/scorecard.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4efa42c4c74742fe81374d95061f5f5e7b404f3047bac5680f000e072f1d403c"
    sha256 cellar: :any_skip_relocation, big_sur:       "3f719c911485669ddae5bef55f0bf2b50d4c858e89a58f28c2a72cc65150207e"
    sha256 cellar: :any_skip_relocation, catalina:      "fa47bdb149664505804b1d51d7ef8a65f99fe67e44cc29c003d6406c8d605b1e"
    sha256 cellar: :any_skip_relocation, mojave:        "f49477d3f8ffd800c41418f40d1aeea25628a957de2466e368f6e1a02ca5d86c"
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
