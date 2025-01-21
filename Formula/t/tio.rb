class Tio < Formula
  desc "Simple TTY terminal I/O application"
  homepage "https://tio.github.io"
  url "https://github.com/tio/tio/releases/download/v3.8/tio-3.8.tar.xz"
  sha256 "a24c69e59b53cf72a147db2566b6ff3b6a018579684caa4b16ce36614b2b68d4"
  license "GPL-2.0-or-later"
  head "https://github.com/tio/tio.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "38f4f70905451183fad4051c989e0413566236dde34909fd695d64b52d333c7f"
    sha256 cellar: :any, arm64_sonoma:  "430ac18ea09829b2d4936a8745ff8f283ffd024cfa2a82c07579150eaec395b8"
    sha256 cellar: :any, arm64_ventura: "85f54e24ddc2ffa80e50318e185468ec0149719b1fb9abf804e1c972c4dd5cb1"
    sha256 cellar: :any, sonoma:        "4abf71b12f17dbe57c4ec145228c54bf0478a5bc599579e0885def3a583dca29"
    sha256 cellar: :any, ventura:       "b41d2c80312869927a8b692cf88e280d953d0d63b0d3bdb9890040a3daebd66b"
    sha256               x86_64_linux:  "73f6272f22e12b44d89f7966cfdbca29110131cebc9e9d76e826d9a05fcdf930"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "glib"
  depends_on "lua"

  def install
    system "meson", "setup", "build", "-Dbashcompletiondir=#{bash_completion}", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
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
