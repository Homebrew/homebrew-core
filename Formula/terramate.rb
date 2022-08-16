class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://github.com/mineiros-io/terramate"
  url "https://github.com/mineiros-io/terramate/archive/refs/tags/v0.1.21.tar.gz"
  sha256 "beaa66705260f73d8cf1dcf1a77465ec0cb83587115cd621faa17e7ef5f8a839"
  license "Apache-2.0"
  head "https://github.com/mineiros-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c106467b0f88a26f9e029908be2eae1fd07ace788573b37e4bc482666c5a805c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9e963ace7025df81d32fd8222be36ff4b5db73149ba759717d7894ebf847c16c"
    sha256 cellar: :any_skip_relocation, monterey:       "d12c63b8376318c93a43de27207b56cb7dc5eaa67c008ece59e98513130819fc"
    sha256 cellar: :any_skip_relocation, big_sur:        "ceb3a4c2c5450747b2f14054454148d979cc9e6554858d271d7941a01df96982"
    sha256 cellar: :any_skip_relocation, catalina:       "ceea922648f97b5cd1ec15011e3b1887608bad41ff6834da7c1d8932801e1368"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5a4fb69687dc233edee4f24fd955d50d7aa90131a1cddda7a6ca2ab2590498c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/terramate"
  end

  test do
    assert_match "project root not found", shell_output("#{bin}/terramate list 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/terramate version")
  end
end
