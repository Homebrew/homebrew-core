class Slides < Formula
  desc "Terminal based presentation tool"
  homepage "https://github.com/maaslalani/slides"
  url "https://github.com/maaslalani/slides/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "90448a3e7672590ed389298705262b6e881a5d1ac5926066be989f0d52f3cfe5"
  license "MIT"
  head "https://github.com/maaslalani/slides.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4fb812d67dbe79402be8800b85270c74ccea66981d2f7b8fd82c335e7497eb20"
    sha256 cellar: :any_skip_relocation, big_sur:       "264c05d4a09f6468c5ccda44101cc3f30450e59e33b2772990eaa1887b7aadb9"
    sha256 cellar: :any_skip_relocation, catalina:      "ebd1ae81a15ae36093d33ded3d8066df306bf0bd1efd33d1855b248004153f0a"
    sha256 cellar: :any_skip_relocation, mojave:        "80f804d7ac9fc91fe453be3c303561b266e39b8214d40a73f7faaadd45d47f66"
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
