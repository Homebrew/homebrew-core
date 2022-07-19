class Tio < Formula
  desc "Simple TTY terminal I/O application"
  homepage "https://tio.github.io"
  url "https://github.com/tio/tio/releases/download/v1.46/tio-1.46.tar.xz"
  sha256 "b97f3ee558c41bb4e605c8cd26f81dc6df167a46c1859927811c3c510cd517a8"
  license "GPL-2.0-or-later"
  head "https://github.com/tio/tio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f1382007f8d4dfd359dfc7246aef0648cd8b9e8ab19f634b48e0443950d9695f"
    sha256 cellar: :any,                 arm64_big_sur:  "4b52020b7c9dd70e54f1ef9a6532b4af936bfaa5fb41de1c7db6ebf62e9d3431"
    sha256 cellar: :any,                 monterey:       "bf43a60de78a72a5a008ad8030c56706afdd06944a743293e264e727bfc22ef8"
    sha256 cellar: :any,                 big_sur:        "b27271e6fb04f692f89734ea905f604fc34076a7b97b06c5971499000c3f9059"
    sha256 cellar: :any,                 catalina:       "e51e62b4fcf93ec2ef1cb6671edff2a859b370e9a01d4e70e0cfceccfeb75575"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee6834d1fd538be7faff3959173f830088422e0dbce3c49aaf55491dc1dcf8d7"
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
