class Treemd < Formula
  desc "TUI and CLI dual pane markdown viewer"
  homepage "https://github.com/epistates/treemd"
  url "https://github.com/Epistates/treemd/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "5f110d3ea88884200161d286cab56bc808a59f614f24088c5e8dec619f3a20a7"
  license "MIT"
  head "https://github.com/epistates/treemd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2dc5aca2bd1f3bd8dd8eb2e76dd4d2fe32345b57c2061ce7e75141452f94d7a7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "18ce4b347ebd996ccc53993500baeefbaadb4f23810720aa4cb8557833202e77"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b638337dcc82e9433db4229fd4b2d111df4207383d84c07a58118a09afa6490d"
    sha256 cellar: :any,                 arm64_linux:       "a53f402bec05a410f6b264b9b945b8926d8cb5fc598d4808088a5de3f0421389"
    sha256 cellar: :any,                 x86_64_linux:      "5ee2a2e6ec96709d396d009bbf2c586750b18859503aff8c3380485bb41d6760"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/treemd --version")

    (testpath/"test.md").write("# Test Heading\n\nThis is a test paragraph.")

    begin
      output_log = testpath/"output.log"
      if OS.mac?
        pid = spawn bin/"treemd", testpath/"test.md", [:out, :err] => output_log.to_s
      else
        require "pty"
        r, _w, pid = PTY.spawn("#{bin}/treemd #{testpath}/test.md > #{output_log}")
        r.winsize = [80, 43]
      end
      sleep 3
      assert_match "treemd - test.md - 1 headings", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
