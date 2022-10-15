class Tio < Formula
  desc "Simple TTY terminal I/O application"
  homepage "https://tio.github.io"
  url "https://github.com/tio/tio/releases/download/v2.1/tio-2.1.tar.xz"
  sha256 "6d3edda20ee0c9341fa4226a265e1a73527eb6685aa8d69e06c8390387c5332e"
  license "GPL-2.0-or-later"
  head "https://github.com/tio/tio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e3bc546472e12af9c4b623f3e942985b4db986f3fa378999c423ba8e22f1b101"
    sha256 cellar: :any,                 arm64_big_sur:  "9b32a47c43d2316a644948128726ecb93b7f73516b679a4777e34449e4080aa1"
    sha256 cellar: :any,                 monterey:       "7fbae70803b4198775767af6519d381a13bde5dcfaa65fad0d5075f9f2658662"
    sha256 cellar: :any,                 big_sur:        "9f1037d39e11076c641f15ff8488c50edb73842640e403c374f5d15ba9f05e37"
    sha256 cellar: :any,                 catalina:       "842ef0221268408e620f883236c6e330e628d09d2db7ed10efdffa338cf08421"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1aad1c26f438c1e6a80619610dcae03c91e2104fab2f9f3264707d51b4275e6f"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "inih"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    # Test that tio emits the correct error output when run with an argument that is not a tty.
    # Use `script` to run tio with its stdio attached to a PTY, otherwise it will complain about that instead.
    expected = "Error: Not a tty device"
    output = if OS.mac?
      shell_output("script -q /dev/null #{bin}/tio /dev/null", 1).strip
    else
      shell_output("script -q /dev/null -e -c \"#{bin}/tio /dev/null\"", 1).strip
    end
    assert_match expected, output
  end
end
