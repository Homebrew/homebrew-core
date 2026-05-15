class Treemd < Formula
  desc "TUI and CLI dual pane markdown viewer"
  homepage "https://github.com/epistates/treemd"
  url "https://github.com/Epistates/treemd/archive/refs/tags/v0.5.11.tar.gz"
  sha256 "87bee07aa427a8d48b91cf8f6309a83863094de7b8a19b694a052816595b8b0b"
  license "MIT"
  head "https://github.com/epistates/treemd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c410c9cf55f1fd3c7569d6da838f7a1d6b244f0f050da925d7fbc961e39d31ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d14f3d03f3561e47a19f91cd44aed859f08aa2a72c8d373d4523546d41aa3cb2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ff5012f3e28b292f2fcc6926eade9f904a66eb3feac5c5f8c4e230b4b0e794e"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f1b0dd73d75cc92323e802983663321d9f21494518d99c4eb36e55083848058"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0bcdbb0cccab5a498ac644e5a96190a531fa773dbd7ddb603429bfa19f69925"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9fcb8544237de119133c15b89134237fcfdd998e5f4867e1a84029c0120316c6"
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
