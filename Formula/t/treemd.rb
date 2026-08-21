class Treemd < Formula
  desc "TUI and CLI dual pane markdown viewer"
  homepage "https://github.com/epistates/treemd"
  url "https://github.com/Epistates/treemd/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "18c61bedcc37948900a191865d575545e651b50f76dd3a88452d4a74cb48b25d"
  license "MIT"
  head "https://github.com/epistates/treemd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d3e1a2187d350de4af8007dd50fcc201e2614a950fc7c77601f26f63a97b04a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b2ae419b4893d9e78782f5073c4adbfcffb7132fbb819dbe649803c9f3e59d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ffb522063d6d5bbd28a9345addf449ad40ac717b5de46d5a9269d59a40cbc694"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9d4164f3fa96282e44103fc0d84c73e08b3c1df8415002679f0fee7d332ead6"
    sha256 cellar: :any,                 arm64_linux:   "72f6129262c17ad66a30c9dff4d5851d00bbf2ba68ee85948604f9b6730f9486"
    sha256 cellar: :any,                 x86_64_linux:  "d99f1f3338b6db9f895b02224cc9a10c0148da596a114b357dad364b37b2aeb9"
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
