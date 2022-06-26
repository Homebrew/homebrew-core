class Tio < Formula
  desc "Simple TTY terminal I/O application"
  homepage "https://tio.github.io"
  url "https://github.com/tio/tio/releases/download/v1.40/tio-1.40.tar.xz"
  sha256 "beafc4763552ff7cf3a368e8af36258018ef85fac32133c4635051d7615ab527"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6db8b849e260c8aaf4277fd9c953f7b53d94b14455c84eeb47316e75cc97f6a4"
    sha256 cellar: :any,                 arm64_big_sur:  "aad6e24a0bcc292168bf02805924d68f3636c072b4f82f1175b8ad424c305b09"
    sha256 cellar: :any,                 monterey:       "67867c2b1f0460c89804037c3a36e75acb4f1b5de5bc95cbbd390807862f1d2f"
    sha256 cellar: :any,                 big_sur:        "e6a586eb7df30ac97d13196c2ea1ce6bc0d5df7529b232100ff01c2c47e769e1"
    sha256 cellar: :any,                 catalina:       "9158c3b4e216aa37637d9216c56f8cccd21aea0dde67c6fcae19061c381d4796"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "612e100468b4fa7235328c4ec199ac84d59f8e433992d0df95ea5e192628f0de"
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
