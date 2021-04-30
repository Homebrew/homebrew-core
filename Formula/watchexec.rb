class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://github.com/watchexec/watchexec"
  url "https://github.com/watchexec/watchexec/archive/1.15.3.tar.gz"
  sha256 "b8c2c6f8a90fbb4ee99a2be95972565ae0bb03ee3e2f6d5561fed9680db8d81e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "869b2ffb1ed4cabea75876b6c5bb2a346e38794812fb97bcb8ea5e37a96697e6"
    sha256 cellar: :any_skip_relocation, big_sur:       "00567d7b4de6c23d831b460c24eb24393e06d04def6fe7a6f6db71c73230ae0f"
    sha256 cellar: :any_skip_relocation, catalina:      "7c08b01a5399f882b4766a013292647d7b1a85b740cf4417dbe62e36fa5379f1"
    sha256 cellar: :any_skip_relocation, mojave:        "3551d6cdc5fe3b305e3174d98ad26ea07f59fcd17f261391200766aa2cc9a00c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "doc/watchexec.1"
  end

  test do
    o = IO.popen("#{bin}/watchexec -1 --postpone -- echo 'saw file change'")
    sleep 1
    touch "test"
    sleep 5
    Process.kill("INT", o.pid)
    assert_match "saw file change", o.read
  end
end
