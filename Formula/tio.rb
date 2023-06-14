class Tio < Formula
  desc "Simple TTY terminal I/O application"
  homepage "https://tio.github.io"
  url "https://github.com/tio/tio/releases/download/v2.6/tio-2.6.tar.xz"
  sha256 "2ce4e8810eb620a40b2a69c4e89ed42df7e48a9ee70cba04d84c5a31aaf5764c"
  license "GPL-2.0-or-later"
  head "https://github.com/tio/tio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "34f93f5534867425afa045aded22e02f39d1afeb5a9b6c0a434d781ff1dabe95"
    sha256 cellar: :any,                 arm64_monterey: "f8cdd8d7a484523698a6f0833a956abe150f18fe8fa9f3baed626ab0781fece3"
    sha256 cellar: :any,                 arm64_big_sur:  "2d3865ec09ff36c2acdeeb9c0cb5c3c98938c0c95601682b1a4c8e5f08d30497"
    sha256 cellar: :any,                 ventura:        "07604c84c5d3f8fe0d82ac0c398c347a3887ed21315ab90696d79ece745506e6"
    sha256 cellar: :any,                 monterey:       "96e46463daad5d5dcc68c7615ed5f46d39f3ddbb59ff9ad3a7b4cf0919454d1a"
    sha256 cellar: :any,                 big_sur:        "46f9024952364369fd038d6477802fa94cdc893beb24e6d3ae5bfdc079dd1b1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5fe8cb37bc544469f1ee03fc2fc6550b9131fe6e3c9bc070df1c0b154eef748f"
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
