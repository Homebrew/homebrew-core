class Superfile < Formula
  desc "Modern and pretty fancy file manager for the terminal"
  homepage "https://superfile.netlify.app/"
  url "https://github.com/yorukot/superfile/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "aa3ad00b3b89023c413a47f4f518f419d37ed3646eac3e9cfaf53d31e5dee82e"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6a186421dbc71c7d1c870004a24af1a6a1adf70512167c79183dd64ee7162848"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20fd7376d766f55ef9551a46512ec96c5f6e44834b3684a8d2d0d3abc0095585"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c59f76e26b950001394334dfc4852f9c3f2471f31bf52962f8731aa5c302dd8"
    sha256 cellar: :any_skip_relocation, sonoma:        "d427f3bee44d568f7ae0965851193bfeac24ee33490a932e4e3b47207a177a83"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e60b1b946d7a173b62ee3e3e2cfd8d83893e12341215d2a9fe6ed41addb54a51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ac1d6b2eb709afd8ce241449f7bf1baf1d6e73ddfe2b60ab1e3192d5ee21a19"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"spf")
  end

  test do
    # superfile is a GUI application
    assert_match version.to_s, shell_output("#{bin}/spf -v")
  end
end
