class Slides < Formula
  desc "Terminal based presentation tool"
  homepage "https://github.com/maaslalani/slides"
  url "https://github.com/maaslalani/slides/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "c4f441e667c44ed97191be1974ee70d43a0b421104a9f432b9dda300399e0166"
  license "MIT"
  head "https://github.com/maaslalani/slides.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4c20d2700108e6f2980c50d784f13e5dbf074edf69f0604328959ca243bb587b"
    sha256 cellar: :any_skip_relocation, big_sur:       "98b260f9abf8584d5e9aba3477e77a9c3fc9b81d6b266c83686df02c260d2fd0"
    sha256 cellar: :any_skip_relocation, catalina:      "93a837175fe373a66eb848aebadd826051b05e1b04c7698b26253dce5f8775ac"
    sha256 cellar: :any_skip_relocation, mojave:        "9e66e59d0b58600cba3fd649762dd25d864169be1f37caddf947a3d4a2610657"
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
