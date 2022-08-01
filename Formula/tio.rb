class Tio < Formula
  desc "Simple TTY terminal I/O application"
  homepage "https://tio.github.io"
  url "https://github.com/tio/tio/releases/download/v1.47/tio-1.47.tar.xz"
  sha256 "6f39ac582de747feb9a64c14e6b378c61cb0c3bfa6639e62050022c1b7f5c544"
  license "GPL-2.0-or-later"
  head "https://github.com/tio/tio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d05b8ebc37c31cf477ceabadb2758f038fb87b31d990b7885b44d365cec8177c"
    sha256 cellar: :any,                 arm64_big_sur:  "d1843f83445ab49ccf0b56d18dc7cd4b1e6966d7e0d3d75afcb38274a5a902ab"
    sha256 cellar: :any,                 monterey:       "2606c527fb96558e73a29563708894be3b8f1b9c4f3d3552f7c693c606f9aff4"
    sha256 cellar: :any,                 big_sur:        "b193fba509ff0dfec5935cec23db9330186ac92710f246f0700d79e3b33708f2"
    sha256 cellar: :any,                 catalina:       "64bba6db50daeb09aef1266cd9af94b14839f92428aa5f3c0912154f77765f5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b4b8fedd35fca7dc5906d18c9f3e5543911e222ecdc3bf248b5e20a65532509"
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
