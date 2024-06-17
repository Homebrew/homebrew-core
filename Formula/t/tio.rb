class Tio < Formula
  desc "Simple TTY terminal I/O application"
  homepage "https://tio.github.io"
  url "https://github.com/tio/tio/releases/download/v3.4/tio-3.4.tar.xz"
  sha256 "4fdc91b257b10e401ae0b0200db9f8fcf14460193e92c8e67fddc85e11a8c911"
  license "GPL-2.0-or-later"
  head "https://github.com/tio/tio.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "10d4113a1ff8cdd491ea097880af983b1a0050f83f31e0e4b9e27d774a03f2cd"
    sha256 cellar: :any, arm64_ventura:  "5e2cda08a596874609b9b9979b99edf0d8bc0faad0ca86b385eaab7ede61c01c"
    sha256 cellar: :any, arm64_monterey: "ff53448ad6bb14e83edc0decab8940070be5e03a603bfa467899724944712af2"
    sha256 cellar: :any, sonoma:         "e63f78acdb57373635884ffaed8d5480015bb1978fecaeab8585a6a6bbdfacce"
    sha256 cellar: :any, ventura:        "ee037ae786e83ec7bfab3cc6cdc21ac5da28746daf0cd0cd5c57574b8fe10152"
    sha256 cellar: :any, monterey:       "e59827f73f00c6eaa9d7a251910a2e66c389eb0f4b2bb73c05c89c3cffe3c402"
    sha256               x86_64_linux:   "d8ec08f3861b8e29399392b2ccf3ade3b1e4ce7ea1b8222cd0bebe634ec9ffc9"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
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
