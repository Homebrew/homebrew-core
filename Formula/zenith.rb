class Zenith < Formula
  desc "In terminal graphical metrics for your *nix system"
  homepage "https://github.com/bvaisvil/zenith/"
  url "https://github.com/bvaisvil/zenith/archive/0.10.1.tar.gz"
  sha256 "66a6b199ca59970217bbbe4c494408f4b2da02884d1195c9f3e2f8124fc98715"
  license "MIT"
  head "https://github.com/bvaisvil/zenith.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6bbe3db614e24831a888b82ebd52ab7f51f00320ee1d0372d8f19c042d8b0505" => :catalina
    sha256 "764dc52d56fa24ff051e66f29a60f11be8e2e229592448662192f604e91f9d5e" => :mojave
    sha256 "5850d5fe7b4ffebb904ea367a3f8d8361b48361e3e0dc9635304baddfebbe0db" => :high_sierra
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
