class Treemd < Formula
  desc "TUI and CLI dual pane markdown viewer"
  homepage "https://github.com/epistates/treemd"
  url "https://github.com/Epistates/treemd/archive/refs/tags/v0.5.9.tar.gz"
  sha256 "e47c8621f5f4bd3930aace0847ec46b6bba9205ef6116a0cf8f6069f783e9dcf"
  license "MIT"
  head "https://github.com/epistates/treemd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "adfbd2215e10939fe2a9f3c4d4850216c7e835eec10f42ef0b9ae9047f232c9f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb35ffb3b8c11f437a2e7e779384377490c87496bfcdb36f7d29093ed59da6d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9fdf188df1308446e0bd442b53229c00b7d0d019dad4e34ef0637384625e0927"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2c9c77fb4f18cfd81124e750b69fa77bf804323d18cbe0600a064c39b9ca367"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03792b81b2fa4605d457a1928e950685e1f5e9d7a88d9a4198b78f7080ad5f58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be75e3613547c587673e011d79fffd12ec025a31d22c8079c96011220ab0d3cc"
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
