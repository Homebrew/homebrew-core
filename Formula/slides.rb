class Slides < Formula
  desc "Terminal based presentation tool"
  homepage "https://github.com/maaslalani/slides"
  url "https://github.com/maaslalani/slides/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "e93fde699dc3fd8db8bb36b2d89871089f5ba35c8fd407d4f8bdcb4ed4ce6c3b"
  license "MIT"
  head "https://github.com/maaslalani/slides.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a6e085526f3cfe257b87273e912a147f2400fb563e784ba2e0547293893769b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "17056f16da03e15f0fb17d0aa52d6e06542b8b4f17ccf4a060904e45ab4e9ec3"
    sha256 cellar: :any_skip_relocation, monterey:       "fdddd44cf36c91dc6e55a5fbfa97acb40122692572c7cdffdcae642ebf1710ab"
    sha256 cellar: :any_skip_relocation, big_sur:        "b63ef5fc2d3bdb2412cf338f320624f49026582c02fc789b5d33371a09948bf0"
    sha256 cellar: :any_skip_relocation, catalina:       "5587929d8f98cf22a246e525abc2b3a6dc45d3b4dbad5f4651f294900a9ae80b"
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
