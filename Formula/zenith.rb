class Zenith < Formula
  desc "In terminal graphical metrics for your *nix system"
  homepage "https://github.com/bvaisvil/zenith/"
  url "https://github.com/bvaisvil/zenith/archive/0.11.0.tar.gz"
  sha256 "be216df5d4e9bc0271971a17e8e090d3abe513f501c69e69174899a30c857254"
  license "MIT"
  head "https://github.com/bvaisvil/zenith.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fb3bf567a186ff31b7dece427dc0244d5985f7d4c0119a60dff2775be8e08006" => :catalina
    sha256 "f25ad39995519a869e01f3c715b5b483b4c8ee1a071fa5d806419855c197b780" => :mojave
    sha256 "a75c6582501ba73ebf97479549fde6ee1e087859bfe78cdf28589c3a985d53f7" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
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
