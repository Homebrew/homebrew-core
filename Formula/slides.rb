class Slides < Formula
  desc "Terminal based presentation tool"
  homepage "https://github.com/maaslalani/slides"
  url "https://github.com/maaslalani/slides/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "e6c62bdec83cfe71562a27ecacd9d1510a5355888d69d8d6508bf7b0a189e0ff"
  license "MIT"
  head "https://github.com/maaslalani/slides.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e3b32d0162ec01524c65ea493caf0f85b4deb3f1170db200af192e0b86ffbb0c"
    sha256 cellar: :any_skip_relocation, big_sur:       "38098f9ad9dad636274924e4455a8a7a014050e23f62b92461159fc94aabc9cb"
    sha256 cellar: :any_skip_relocation, catalina:      "58c05f8d308375761bf2acb2477103206afe5fbbf721359cc8d387be20edb5b7"
    sha256 cellar: :any_skip_relocation, mojave:        "c015e54815e32ce310f4743f971bfbb2ef44afc662c7b1714908cdc7254d2b88"
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
