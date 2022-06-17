class Tio < Formula
  desc "Simple TTY terminal I/O application"
  homepage "https://tio.github.io"
  url "https://github.com/tio/tio/releases/download/v1.40/tio-1.40.tar.xz"
  sha256 "beafc4763552ff7cf3a368e8af36258018ef85fac32133c4635051d7615ab527"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0514e8774caadc2ec58e85ea1423258cba117ea2ed40e0c3b2fe1318591346e2"
    sha256 cellar: :any,                 arm64_big_sur:  "2792cdaae3bf058436da3cf66696773c234f48d6915174cab748912a726dda92"
    sha256 cellar: :any,                 monterey:       "6f3b2aec1b8dcecce6c56d91ef144d754f7b0d958f39cbd4357a6959ac16f2cb"
    sha256 cellar: :any,                 big_sur:        "82c250ad2a425bdbe586edad4f3e5ef8962381b3efe8cae41cda794ed2a8e3c7"
    sha256 cellar: :any,                 catalina:       "c01f10c9e6b886df7d0cd298d226463f76f940ffc51a0dd5806d36fe7c0af1b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c21b9efec1dc1ea47e535bfa9c31b70aec7da80c1a29edaa02aa6b363ee71d12"
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
