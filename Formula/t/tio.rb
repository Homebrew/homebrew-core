class Tio < Formula
  desc "Simple TTY terminal I/O application"
  homepage "https://tio.github.io"
  url "https://github.com/tio/tio/releases/download/v3.6/tio-3.6.tar.xz"
  sha256 "04a91686f8a19f157b885a7c146a138b4cff6a3fb8dba48723d1fdad15c61167"
  license "GPL-2.0-or-later"
  head "https://github.com/tio/tio.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "e21b5db45b997387be149e757a17219d6a132520803f5b6ff9dc9876b99c4da3"
    sha256 cellar: :any, arm64_ventura:  "7dca2cb864b1b26862c3497760537e291ad60f177aee4ef36097936f34c3a85c"
    sha256 cellar: :any, arm64_monterey: "7a27b15f8631beb6a3b3f52294d61512d2fef4ba1a0ff12c421dc98938dd44a7"
    sha256 cellar: :any, sonoma:         "553d53f3c409f4884f0ea0e0160673da5ac0a9bd4889d290f39183e9521fab97"
    sha256 cellar: :any, ventura:        "712718a9a41bd8be856e4f99646f553a74db9937e2a10d1d145fa31b8ffe4e4c"
    sha256 cellar: :any, monterey:       "0d527af33c975555de83a519cd0a50263be3311b36654567dd8cc09b0d38b892"
    sha256               x86_64_linux:   "f46497f793be55fdf41963b13a870ec53d19c64cd874eb64518822dfe3a5b53d"
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
