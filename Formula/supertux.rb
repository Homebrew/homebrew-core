class Supertux < Formula
  desc "Classic 2D jump'n run sidescroller game"
  homepage "https://www.supertux.org/"
  url "https://github.com/SuperTux/supertux/releases/download/v0.6.2/SuperTux-v0.6.2-Source.tar.gz"
  sha256 "26a9e56ea2d284148849f3239177d777dda5b675a10ab2d76ee65854c91ff598"
  license "GPL-3.0-or-later"
  head "https://github.com/SuperTux/supertux.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "a3d50acf760264c99f3f2bb9e02bca8dbbadc2d4f2c3a7e9b9995316a22cfa3d" => :catalina
    sha256 "006225504f80952487eb62f66359ac5976248ec4de46f266915f41f543e4742a" => :mojave
    sha256 "66385b85ba64e6ce35f5d74e9c2304e73795b977b75f814ff4eeb55cbfccba0b" => :high_sierra
    sha256 "fbde2e2249a89401fd9893b095857b283c4a7a3a4ab9dec47b8c30d2030d0268" => :sierra
    sha256 "c66b6e14fc23160f5024ad7790286ec0bcb7f8ed262ce6c400dc8757c1c16ba8" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "freetype"
  depends_on "glew"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"

  def install
    unless build.head?
      # Fix for `external/findlocale/VERSION` is trying to be compiled (on case-insensitive FS)
      # This mimics behaviour of https://github.com/SuperTux/supertux/commit/afbae58a61abf0dab98ffe57401dead8f7f1c0dd
      # Remove in the next release
      File.rename "external/findlocale/VERSION", "external/findlocale/VERSION.txt"
    end

    ENV.cxx11

    args = std_cmake_args
    args << "-DINSTALL_SUBDIR_BIN=bin"
    args << "-DINSTALL_SUBDIR_SHARE=share/supertux"
    # Without the following option, Cmake intend to use the library of MONO framework.
    args << "-DPNG_PNG_INCLUDE_DIR=#{Formula["libpng"].opt_include}"
    system "cmake", ".", *args
    system "make", "install"

    # Remove unnecessary files
    (share/"applications").rmtree
    (share/"pixmaps").rmtree
    (prefix/"MacOS").rmtree
  end

  test do
    (testpath / "config").write "(supertux-config)"
    assert_equal "supertux2 v#{version}", shell_output("#{bin}/supertux2 --userdir #{testpath} --version").chomp
  end
end
