class Tio < Formula
  desc "Simple TTY terminal I/O application"
  homepage "https://tio.github.io"
  url "https://github.com/tio/tio/releases/download/v1.45/tio-1.45.tar.xz"
  sha256 "4e72a946792346f86504865ed2923688f4dd9281905bb81e76ba3fd6f3b96014"
  license "GPL-2.0-or-later"
  head "https://github.com/tio/tio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2fe0dbaef03a546dea0f861cb6dcfd044c1bb5dd59f0fa3f701e504a9bf30c11"
    sha256 cellar: :any,                 arm64_big_sur:  "f1935feeffdb9b019ebd099d0fe3d855f6e30c675fab1e8dccec256ad58702e5"
    sha256 cellar: :any,                 monterey:       "427ced11723fbf28ab3ee668d0b7c7b6b96d7aaf7fb5c32eb157b83a70768704"
    sha256 cellar: :any,                 big_sur:        "83c288a9e5300a745d6e5ebdda16fad647de824916c1afc2f4f178de4d888eac"
    sha256 cellar: :any,                 catalina:       "d75991647af2167e10d3dd6273c823c363ae1ed4bec6936e7e8b3dcacd531474"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c7cc52463ea91c23c6dd4b25dcdd30fc4c8afff59af9f01eb3e594374cc1593"
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
