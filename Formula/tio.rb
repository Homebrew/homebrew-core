class Tio < Formula
  desc "Simple TTY terminal I/O application"
  homepage "https://tio.github.io"
  url "https://github.com/tio/tio/releases/download/v1.47/tio-1.47.tar.xz"
  sha256 "6f39ac582de747feb9a64c14e6b378c61cb0c3bfa6639e62050022c1b7f5c544"
  license "GPL-2.0-or-later"
  head "https://github.com/tio/tio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c989f1cb47c3739d30dcefbf2398e071252b54c781efd202f0de5e842f6d270c"
    sha256 cellar: :any,                 arm64_big_sur:  "4e8dde5e9431993dc56966d687597028d6cd074cb04aa8ab51cc869be75d505f"
    sha256 cellar: :any,                 monterey:       "6c052c3e742929d293458beca1c4c820fba75ef175a25739fb0cb259718d8114"
    sha256 cellar: :any,                 big_sur:        "d12e589a6724fd23fb8f63f5bb9502c0fd157e9c8d275f8d20954b27a5046c15"
    sha256 cellar: :any,                 catalina:       "ed2609fc93a40a23e670acc096ce50a2878a6ef0e37c7cb3db886185eda31d97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb0d6d4095f1b3253dcfb144dde76db28a0b8edd0d2ff647de8409db5dba3166"
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
