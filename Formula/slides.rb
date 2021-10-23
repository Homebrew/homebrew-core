class Slides < Formula
  desc "Terminal based presentation tool"
  homepage "https://github.com/maaslalani/slides"
  url "https://github.com/maaslalani/slides/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "67de7cd34317bfba774102c690cd7de9f6d5b8f0271d34c1a5eff5fbb22f36b8"
  license "MIT"
  head "https://github.com/maaslalani/slides.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "94ab2bb99a5dea08f82a21e6a408ec214a4e9e10741a0def28c15a340c2265b4"
    sha256 cellar: :any_skip_relocation, big_sur:       "e1f04b073420a28cefdb9d4822c10e62df1374e02bcc29cf1267505ede92076e"
    sha256 cellar: :any_skip_relocation, catalina:      "377db7839b7c463ec0f85cf6072c07be639963f99c5f0c7521465ab98e3f35a5"
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
