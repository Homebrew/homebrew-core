class TrzszGo < Formula
  desc "Simple file transfer tools, similar to lrzsz (rz/sz), and compatible with tmux"
  homepage "https://trzsz.github.io"
  url "https://github.com/trzsz/trzsz-go/archive/refs/tags/v0.1.9.tar.gz"
  sha256 "f39c930360a36788f13f26da6792fcce09674e45beb539f0b4b4a747d17576ab"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "236473aa975543af390aaa4f8e65c49ecd8a407e2d867a09a02998156c37062c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "81851185ec81d689eaf3bb5319165bb586dc628e059eb7d877951614fd0bc205"
    sha256 cellar: :any_skip_relocation, monterey:       "53f380167227a17956a13dc6973144dba444227247f6e2589ad647d84341a12a"
    sha256 cellar: :any_skip_relocation, big_sur:        "965c0db925939162bd15554a8a8896999484056616e6181c389e3afec473abc9"
    sha256 cellar: :any_skip_relocation, catalina:       "2e6d4df459d51b4d512a510d5c30c57a1cb2d00927d0419b2433f2f056f4c257"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9c1b44166630f0fa88c2e45af3e660fb9a35ffa4457d062f6f3aa04a2afedcb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"trz"), "./cmd/trz"
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"tsz"), "./cmd/tsz"
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"trzsz"), "./cmd/trzsz"
  end

  test do
    assert_match "trzsz go #{version}", shell_output("#{bin}/trzsz --version")
    assert_match "trz (trzsz) go #{version}", shell_output("#{bin}/trz --version")
    assert_match "tsz (trzsz) go #{version}", shell_output("#{bin}/tsz --version")

    assert_match "executable file not found", shell_output("#{bin}/trzsz cmd_not_exists 2>&1", 255)
    touch "tmpfile"
    assert_match "Not a directory", shell_output("#{bin}/trz tmpfile 2>&1", 254)
    rm "tmpfile"
    assert_match "No such file", shell_output("#{bin}/tsz tmpfile 2>&1", 255)
  end
end
