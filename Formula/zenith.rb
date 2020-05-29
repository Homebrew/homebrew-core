class Zenith < Formula
  desc "In terminal graphical metrics for your *nix system"
  homepage "https://github.com/bvaisvil/zenith/"
  url "https://github.com/bvaisvil/zenith/archive/0.9.2.tar.gz"
  sha256 "dbfcb76698201891b44b1178022e6fa480e8bfd6ded33af04031edcc6685d6de"
  head "https://github.com/bvaisvil/zenith.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "519f1e90f11202428e2ec514afef74f61a34d12d9fdc8a9a5d295bac888c7334" => :catalina
    sha256 "02b1c439da9a12b1442a525f899153478488742604e54922753641fa5f0615cf" => :mojave
    sha256 "ba1494134a8d6d5a0ae5c52c7b1586d79340938b2b67c77ab3425d2b1ae9c117" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    require "pty"

    begin
      (testpath/"zenith").mkdir
      cmd = "#{bin}/zenith --db zenith"
      output, input, pid = PTY.spawn "stty rows 80 cols 43 && #{cmd}"
      sleep 1
      input.write "q"
      assert_match /PID\s+USER\s+P\s+N\s+↓CPU%\s+MEM%/, output.read
    ensure
      Process.kill("TERM", pid)
    end
  end
end
