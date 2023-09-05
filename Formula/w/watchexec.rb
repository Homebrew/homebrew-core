class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://github.com/watchexec/watchexec"
  url "https://github.com/watchexec/watchexec/archive/refs/tags/v1.23.0.tar.gz"
  sha256 "2a321962669979feef44ea7a6220819d5c916ca939eba41b033ea346a44caa90"
  license "Apache-2.0"
  head "https://github.com/watchexec/watchexec.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:cli[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "65b8a41d554e9c60ac46d6e4597466c734628ead7ed3204314f9cc84fe4fdbdf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca06a1807059dc29baf7d86f14947b2d98e310de73186e66ac6015a0d600b9b8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b7f41a7b63d419a745ffefa9e5a10552ea80f1f746ec1b883d9207931789e2ae"
    sha256 cellar: :any_skip_relocation, ventura:        "72bb7a376ac94c176d9260b5066cd98059fb314968f070f0d9067cd0b6b22f99"
    sha256 cellar: :any_skip_relocation, monterey:       "df2a60f908e2320dc5be874be83b20571d067408ede685b49a1aefca8d291968"
    sha256 cellar: :any_skip_relocation, big_sur:        "aa59a8de9c810d221d7c5c22c5bd4ebc93589f2b5d19c5ebd08f425443ea97bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23423161e6b28b6e5f99df05c81e1331d1fa15fca4551d7ba14b3f4d70742114"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
    man1.install "doc/watchexec.1"
  end

  test do
    o = IO.popen("#{bin}/watchexec -1 --postpone -- echo 'saw file change'")
    sleep 15
    touch "test"
    sleep 15
    Process.kill("TERM", o.pid)
    assert_match "saw file change", o.read
  end
end
