class Tio < Formula
  desc "Simple TTY terminal I/O application"
  homepage "https://tio.github.io"
  url "https://github.com/tio/tio/releases/download/v3.9/tio-3.9.tar.xz"
  sha256 "06fe0c22e3e75274643c017928fbc85e86589bc1acd515d92f98eecd4bbab11b"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/tio/tio.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6cb51485dcb3c3ecd0cfc60130ee73ea411e49b221aece71c220ea308a429cf4"
    sha256 cellar: :any, arm64_sequoia: "bac206b4c14cd4070ea893cfcd4ceba2e103c7031ce31223221441462fc326f5"
    sha256 cellar: :any, arm64_sonoma:  "a69f119bcd8f576264bd7de362f0d9f949272b885fa5d6dbff88b91c9ab8a1e9"
    sha256 cellar: :any, sonoma:        "6205aa635e36060d9dda5af20f21cbd293c496be2039bfc340849aacc10cbb13"
    sha256               arm64_linux:   "5f92757b91dc466fa689ba967a097e24d0eb0a5357b84e7fae59095b803dba30"
    sha256               x86_64_linux:  "f659369b4ff6e0d857a677d8d8ec08bdacaba3dc1a81c7894f5667c7889e1072"
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
