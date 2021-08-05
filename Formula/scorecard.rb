class Scorecard < Formula
  desc "Security health metrics for Open Source"
  homepage "https://github.com/ossf/scorecard"
  url "https://github.com/ossf/scorecard/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "9db79e73b7bccdc385d857bdab773b5cf10f70ca64c9828320b7e125a11c0222"
  license "Apache-2.0"
  head "https://github.com/ossf/scorecard.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d9ca05a8f8cc8829a7373138a55c669a5410e204697d5d988fe4123beb5f74ff"
    sha256 cellar: :any_skip_relocation, big_sur:       "0b014909fa2964508aa1925957c52467bae5d92c0c97ec5ade25b16f16558741"
    sha256 cellar: :any_skip_relocation, catalina:      "f9f27172f2817fc621c70a6103b4141226130f0e44f1f5cf5345dbf23b3ee719"
    sha256 cellar: :any_skip_relocation, mojave:        "695fa2f073e4a34a08e8ea5ead9afa9444be6dc21b1a921c9d8448ca2c5e061f"
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
