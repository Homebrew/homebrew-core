class Treemd < Formula
  desc "TUI and CLI dual pane markdown viewer"
  homepage "https://github.com/epistates/treemd"
  url "https://github.com/Epistates/treemd/archive/refs/tags/v0.5.10.tar.gz"
  sha256 "1acf80c147fa87df1621201cb10529a0b6c1b7b85eb5a5e4b4c0559d9ceb7af1"
  license "MIT"
  head "https://github.com/epistates/treemd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "242e6144a5c7e6aedf1d2985c6e9f2d0971f8c588db3bf6358054e7ae210732c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "360d8ccf85d1791966484c0d10d7960f0ec815770994f246ab4fffa2b1c261df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df017df157e580a871708d177ed1e7378d17f6230f1d3516d3fe4f710df25df1"
    sha256 cellar: :any_skip_relocation, sonoma:        "499b7112bc2a467bba14fc62d2f45bc9982b3c322e77cab53518a6a9c10ae1d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "efd0a328340e80a03ba32aa02b68f43a8731b56d8ad96a57d0ad4c95972d5349"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e642e751d59535b119a7e1bc32b3ed6bfe727d749faef013c450ca58eaaea0b"
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
