class Tio < Formula
  desc "Simple TTY terminal I/O application"
  homepage "https://tio.github.io"
  url "https://github.com/tio/tio/releases/download/v1.43/tio-1.43.tar.xz"
  sha256 "fe687042dc787bb28a00a5abbafd99714921704fae7d51eff30aaf5a6dc74ab7"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e44d48352b78a3e525b7fd8dce243079c81f59bf52ea5be8fefbd6479b2ba489"
    sha256 cellar: :any,                 arm64_big_sur:  "92dab2d36b4723a2fada9f41a46330dcbe90c5f559252c0fd50e8a356d857cc3"
    sha256 cellar: :any,                 monterey:       "f56e390b7fda44c27a868d39f10cdf135e854999fc2e0798f4fd84bdc2cca1ee"
    sha256 cellar: :any,                 big_sur:        "9bc2ecf98ae97f6c9967bb6bf2c43e3ffbb0ebe1bbb5ac9ba99bb414d47f04f4"
    sha256 cellar: :any,                 catalina:       "0e1c4cb397dcf2874f5936974b03e86127211f4417b9856da612591c341d6296"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b24fb67b77631e2093938deef388ff24147ecfa53ad625cd070ea2bfbfcc76a"
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
