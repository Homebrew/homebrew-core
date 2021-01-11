class Zenith < Formula
  desc "In terminal graphical metrics for your *nix system"
  homepage "https://github.com/bvaisvil/zenith/"
  url "https://github.com/bvaisvil/zenith/archive/0.12.0b.tar.gz"
  version "0.12.0b"
  sha256 "ba4896d3018264804192daf1e7aa979d31c3acd5d05a8d966301fe3993f3916d"
  license "MIT"
  head "https://github.com/bvaisvil/zenith.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "b6863e0f25d2b1590bba5016f563fa101f8f76f716220d7b2c07c2c2bbc47df2" => :big_sur
    sha256 "a6c9804ff96250b57852555414d3f37e793c379178ffd9b0b00bb4b79ac37c4a" => :catalina
    sha256 "33aeda2cfe6a2e2ce8089e5991b0b41feb201ddaaf250e62796a7e3bd85692ac" => :mojave
    sha256 "34669ca8a79071a5ab3d78ccd80a261984f60711126bd6d35ead14890279fde7" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "pty"
    require "io/console"

    (testpath/"zenith").mkdir
    r, w, pid = PTY.spawn "#{bin}/zenith --db zenith"
    r.winsize = [80, 43]
    sleep 1
    w.write "q"
    assert_match /PID\s+USER\s+P\s+N\s+↓CPU%\s+MEM%/, r.read
  ensure
    Process.kill("TERM", pid)
  end
end
