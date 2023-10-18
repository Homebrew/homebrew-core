class Tio < Formula
  desc "Simple TTY terminal I/O application"
  homepage "https://tio.github.io"
  url "https://github.com/tio/tio/releases/download/v2.7/tio-2.7.tar.xz"
  sha256 "bf8fe434848c2c1b6540af0b42503c986068176ddc1a988cf02e521e7de5daa5"
  license "GPL-2.0-or-later"
  head "https://github.com/tio/tio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8b5af18879b92601b2d54f48016cc38547d84ea924568ecda5bb28b00fc43187"
    sha256 cellar: :any,                 arm64_ventura:  "d88d8a16795a32de17b89d3c996321ab617a5eaa142d2ba28e479895c59ae435"
    sha256 cellar: :any,                 arm64_monterey: "dbafc0da143fdbbf7c6d3de7b87027448e7224a951c27268fe1400d5b8fad0b9"
    sha256 cellar: :any,                 arm64_big_sur:  "56f3900c997c905216b20a75ebdd9169eea400532a82e40cbbfd6ddefe5d59a8"
    sha256 cellar: :any,                 sonoma:         "1a0eac5a04f3628bddfa1a35579597ba59462f6bcede5b728740b38679bb6535"
    sha256 cellar: :any,                 ventura:        "53b6076a88662668a22dfa0b914ac4c05bd568dd707f7f078df4c7f238db2fa2"
    sha256 cellar: :any,                 monterey:       "07d407983719b49255f611569ffc6de78c244446f658120845021137075119e8"
    sha256 cellar: :any,                 big_sur:        "afbc51bc418883782e5b23914b7351f78afde46d2086378f0317052dcc748e83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a696f56d7f0b1676b547743ef45737d135c1f853cd8784366eb9b4a89c8ca7f7"
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
