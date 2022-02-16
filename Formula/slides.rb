class Slides < Formula
  desc "Terminal based presentation tool"
  homepage "https://github.com/maaslalani/slides"
  url "https://github.com/maaslalani/slides/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "1d0c08ece824825a8150c4c92ed4d3cc007eb4aa0fa659a8f3fda4207e0a0b24"
  license "MIT"
  head "https://github.com/maaslalani/slides.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "757f589abd3151b97160f3090567448f41ec4989a1e323ed78e60121a0f678d7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8620a73bb35cd3b35739736118b285363c4318e4bf41bb69a62c80694cea2b61"
    sha256 cellar: :any_skip_relocation, monterey:       "08d65e4c26659f5f52efb31356ee213ec5446fb550cbb52762a4902fa1b0b3c2"
    sha256 cellar: :any_skip_relocation, big_sur:        "0b3b266e13013e3319b778322e764c3c3b07d7aaeba5afd50820015b7e7d39e3"
    sha256 cellar: :any_skip_relocation, catalina:       "b820070e17cd96752f8232f3098d46491850162476d5d40d315898a10b86f293"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    (testpath/"test.md").write <<-MARKDOWN
    # Slide 1
    Content

    ---

    # Slide 2
    More Content
    MARKDOWN

    # Bubbletea-based apps are hard to test even under PTY.spawn (or via
    # expect) because they rely on vt100-like answerback support, such as
    # "<ESC>[6n" to report the cursor position. For now we just run the command
    # for a second and see that it tried to send some ANSI out of it.
    require "pty"
    r, _, pid = PTY.spawn "#{bin}/slides test.md"
    sleep 1
    Process.kill("TERM", pid)
    assert_match(/\e\[/, r.read)
  end
end
