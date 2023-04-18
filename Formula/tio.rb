class Tio < Formula
  desc "Simple TTY terminal I/O application"
  homepage "https://tio.github.io"
  url "https://github.com/tio/tio/releases/download/v2.5/tio-2.5.tar.xz"
  sha256 "063952ee90a78cee180f6e660d6c73773dfc109efcdc151585accfe1500c44a7"
  license "GPL-2.0-or-later"
  head "https://github.com/tio/tio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b930375c3f659075cbf694a4359c57a1faaeaae01d6870755d321f2aac8b736d"
    sha256 cellar: :any,                 arm64_monterey: "b962573188a2f1607f489d6d33dbecbe2a70e69b73aa041ba6f6773410791fa1"
    sha256 cellar: :any,                 arm64_big_sur:  "0273ac11ca8f72191b877b734dd99b791a3ee2cf64e9f2d0bb5709d0f35b80df"
    sha256 cellar: :any,                 ventura:        "e684824b7b74ba4f7fe6d5defc20084462466b83e812bbe8a68a208d2766c09a"
    sha256 cellar: :any,                 monterey:       "db8961e35722fd670a1f8393c20b87b7938f76b54391c6966ca5ebc3165586e4"
    sha256 cellar: :any,                 big_sur:        "4a665334480f8cb670516b8cd96fa6779122795edafd240dd750d312a4867cb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "475c233968a41f7c4335244202d190ca916d0076472dc49c9e48ca527dec0710"
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
