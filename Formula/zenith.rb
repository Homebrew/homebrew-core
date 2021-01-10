class Zenith < Formula
  desc "In terminal graphical metrics for your *nix system"
  homepage "https://github.com/bvaisvil/zenith/"
  # Remove `Cargo.lock` resource at version bump!
  url "https://github.com/bvaisvil/zenith/archive/0.11.0.tar.gz"
  sha256 "be216df5d4e9bc0271971a17e8e090d3abe513f501c69e69174899a30c857254"
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

  # Fix stale lock file. Remove at version bump.
  # https://github.com/bvaisvil/zenith/issues/85
  # https://github.com/bvaisvil/zenith/pull/90
  resource "Cargo.lock" do
    url "https://raw.githubusercontent.com/bvaisvil/zenith/063a187befbd6bd0adda5a61b307b4670a2b7a60/Cargo.lock"
    sha256 "85b6f3850415af48549ff77fb1291fdd710b08c559190520db068b9021a8c002"
  end

  def install
    rm_f "Cargo.lock"
    resource("Cargo.lock").stage buildpath
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
