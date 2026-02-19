class Treemd < Formula
  desc "TUI and CLI dual pane markdown viewer"
  homepage "https://github.com/epistates/treemd"
  url "https://github.com/Epistates/treemd/archive/refs/tags/v0.5.6.tar.gz"
  sha256 "40b01caa9792416cee17ed44e9511eb36689ca3c792881170378e283c1d1ddfb"
  license "MIT"
  head "https://github.com/epistates/treemd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb7879add17ffe677185f39c857031dc1f257fe373cc4f59dc1e3e29d655bd80"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05ffc207eda98099d22794403e790fbc641cfb9fe75e86c8ce9ce5f6ede83055"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b9fe76f8387055c7da177af3963e43a1fe512c3be07e8f3f1336e39eec049ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7abb931c098670144f1c898c077d4f0c59cefe8333921b3c59ec8e3cf27d947"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52fbe2ce801bf84a569d2a5af3cc010220b6252f4976c17c70b7dec822d77547"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d78667f128a291707bf7a9e052175111a3675b59be18e2a152cb691b8184efbb"
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
