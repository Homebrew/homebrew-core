class Tz < Formula
  desc "CLI time zone visualizer"
  homepage "https://github.com/oz/tz"
  url "https://github.com/oz/tz/archive/refs/tags/v0.5.tar.gz"
  sha256 "185445537bd8dee92d6419419a141c38c49643c8dcf507f27d41190629f32f69"
  license "GPL-3.0-or-later"
  head "https://github.com/oz/tz.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b3a0210640c51de3e5d0b6e58e0e1182d940999166fb18cc6f525afa68759ff5"
    sha256 cellar: :any_skip_relocation, big_sur:       "d6e0297beac8111194c6ff95fe33c9c4798cc97d2fd78e2b7c9ff6522b418a29"
    sha256 cellar: :any_skip_relocation, catalina:      "2f85be9fa198c26d89ec48494ec7162d2b4ff3940dba342edc65998be658156d"
    sha256 cellar: :any_skip_relocation, mojave:        "18bac8d9afe7dd3e92cc556bedf34ec20e422b3887bb77936ec1ccdf757c6015"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    # Bubbletea-based apps are hard to test even under PTY.spawn (or via
    # expect) because they rely on vt100-like answerback support, such as
    # "<ESC>[6n" to report the cursor position.  For now we just run
    # the command for a second and see that it tried to send some ANSI out of it.
    require "pty"
    r, _, pid = PTY.spawn "#{bin}/tz", "-q"
    sleep 1
    Process.kill("TERM", pid)
    assert_match(/\e\[/, r.read)
  end
end
