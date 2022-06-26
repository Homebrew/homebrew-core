class Slides < Formula
  desc "Terminal based presentation tool"
  homepage "https://github.com/maaslalani/slides"
  url "https://github.com/maaslalani/slides/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "9180bc3fe88b44fe254c14d89c8554c442c3cfc6a1c1cd8f482db3f3ef13098d"
  license "MIT"
  head "https://github.com/maaslalani/slides.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a0fdb1f344d152e9aa2a9621f70d9116ecb8512db0f7f1aca373d85f568de256"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1b5ee66a9089e7d7a737ab6e94be233da40fba191e9281fb67d1eef096a7dc4a"
    sha256 cellar: :any_skip_relocation, monterey:       "5ccfc7cbbac37cf3ed85e21ac571a324fe4b63be0e273eb1755237fcff0324b4"
    sha256 cellar: :any_skip_relocation, big_sur:        "c1755557a55f16eeeaa3e8fb8b82dd793929bb72d8ad00ed245d54ac1433a7de"
    sha256 cellar: :any_skip_relocation, catalina:       "71cb0d2abac4454af11e6d412452bbe2cbe8351a5d6041b7f16fc9805dfaa1a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b3d3223a79ec3585b538a21bb7d7a6f7de7a7cbf17c6709f060ed7f93705a6c"
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
    begin
      assert_match(/\e\[/, r.read)
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
  end
end
