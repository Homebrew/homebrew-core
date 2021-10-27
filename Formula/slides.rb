class Slides < Formula
  desc "Terminal based presentation tool"
  homepage "https://github.com/maaslalani/slides"
  url "https://github.com/maaslalani/slides/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "67de7cd34317bfba774102c690cd7de9f6d5b8f0271d34c1a5eff5fbb22f36b8"
  license "MIT"
  head "https://github.com/maaslalani/slides.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2d099ef411a8ff3b1e3004d27f03659bae45520875be6c8432eff6b247380d30"
    sha256 cellar: :any_skip_relocation, big_sur:       "e4e45fb8e8c8cebccaf5182d52b459800b35c5b3d789248d4d872a0f1f2b395b"
    sha256 cellar: :any_skip_relocation, catalina:      "63371b5b12cdc44e65ca563e32dab81fca0e6e0bc6bda094a88753b8eecc1349"
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
