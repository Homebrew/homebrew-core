class Slides < Formula
  desc "Terminal based presentation tool"
  homepage "https://github.com/maaslalani/slides"
  url "https://github.com/maaslalani/slides/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "320285f179c4c2de7810f945f6c27c1d57d97f3b4ee322867248f7f1a7c06adf"
  license "MIT"
  head "https://github.com/maaslalani/slides.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d63bea25bc71d0a490cb5b2dc38315f8ecbf73a88c25a32ed0c93e3305c3bcb5"
    sha256 cellar: :any_skip_relocation, big_sur:       "6ff818e86117ee5e10ac422fca50f7d961ee2ca90e7ca3d32a7223c037c67bae"
    sha256 cellar: :any_skip_relocation, catalina:      "c0f9ec6c5114e6b8ba4417a236e99e5314e1acc936c89f2c468503b0bdd861db"
    sha256 cellar: :any_skip_relocation, mojave:        "51b548784cc6f20032c203b4a2803649b9f82014b602131e1d5413a124be4151"
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
