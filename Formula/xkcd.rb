class Xkcd < Formula
  desc "Fetch latest, random or any particular xkcd comic right in your terminal"
  homepage "https://git.hanabi.in/xkcd-go"
  url "https://git.hanabi.in/repos/xkcd-go.git",
      tag:      "v2.0.0",
      revision: "5e68ef5b2e7e6806dd57586e9b7ed4f97f64dba0"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1402d9b256ef081a1667c1e26c6e53d3b8429bd1e58e831555ee27f235b3cde"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c944fe024e4943fbf35e6b0c47de882f49b67815741dfd0a3a7b008500af213c"
    sha256 cellar: :any_skip_relocation, monterey:       "9010a3bec1ae4b24be2bc9c6b2b335456b8f7817a56823a1d69782d4c93dbb9c"
    sha256 cellar: :any_skip_relocation, big_sur:        "c70df4015231c9955bc1d67d3a55a0d70f8486a2444051feaf5997db19893f4f"
    sha256 cellar: :any_skip_relocation, catalina:       "7ce9eb7408f0d114c84be128b66b5654a32552b8489b8159d4e3cfe3c60178da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7748cc8d6d3651b22cd1960ccf30ca9b52314540fdbe5655888dfeee6c33bc0b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "src/main.go"
  end

  test do
    require "pty"
    stdout, _stdin, _pid = PTY.spawn("#{bin}/xkcd explain 404")
    op = stdout.readline
    striped_op = op.strip
    assert_equal striped_op, "https://www.explainxkcd.com/wiki/index.php/404"
  end
end
