class Tz < Formula
  desc "CLI time zone visualizer"
  homepage "https://github.com/oz/tz"
  url "https://github.com/oz/tz/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "96be9896deb2e27452d2dfde4d7121a1bd6fa1f8eec3d3b8f374b4d55626043d"
  license "GPL-3.0-or-later"
  head "https://github.com/oz/tz.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ffcc6e47c89080907b571031d530046fe710d4c74c45183a8981c6c67ed3515a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ffcc6e47c89080907b571031d530046fe710d4c74c45183a8981c6c67ed3515a"
    sha256 cellar: :any_skip_relocation, monterey:       "2ce8046b150966b4e05f0f13255f17d6589650331578256f6f6f41ec25823f81"
    sha256 cellar: :any_skip_relocation, big_sur:        "2ce8046b150966b4e05f0f13255f17d6589650331578256f6f6f41ec25823f81"
    sha256 cellar: :any_skip_relocation, catalina:       "2ce8046b150966b4e05f0f13255f17d6589650331578256f6f6f41ec25823f81"
    sha256 cellar: :any_skip_relocation, mojave:         "2ce8046b150966b4e05f0f13255f17d6589650331578256f6f6f41ec25823f81"
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
