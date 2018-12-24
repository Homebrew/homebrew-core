class Supertux < Formula
  desc "Classic 2D jump'n run sidescroller game"
  homepage "https://www.supertux.org/"
  url "https://github.com/SuperTux/supertux/releases/download/v0.6.0/SuperTux-v0.6.0-Source.tar.gz"
  sha256 "c4c3e5fa6f90e87b8c5ad6b22a179e9a9839bf997e7f219e22bbcd1c97223ac0"
  head "https://github.com/SuperTux/supertux.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "006225504f80952487eb62f66359ac5976248ec4de46f266915f41f543e4742a" => :mojave
    sha256 "66385b85ba64e6ce35f5d74e9c2304e73795b977b75f814ff4eeb55cbfccba0b" => :high_sierra
    sha256 "fbde2e2249a89401fd9893b095857b283c4a7a3a4ab9dec47b8c30d2030d0268" => :sierra
    sha256 "c66b6e14fc23160f5024ad7790286ec0bcb7f8ed262ce6c400dc8757c1c16ba8" => :el_capitan
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "glew"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"

  needs :cxx11

  def install
    ENV.cxx11

    args = std_cmake_args
    args << "-DINSTALL_SUBDIR_BIN=bin"
    args << "-DINSTALL_SUBDIR_SHARE=share/supertux"
    # Without the following option, Cmake intend to use the library of MONO framework.
    args << "-DPNG_PNG_INCLUDE_DIR=#{Formula["libpng"].opt_include}"
    system "cmake", ".", *args
    system "make", "install"

    # Remove unnecessary files
    (share/"appdata").rmtree
    (share/"applications").rmtree
    (share/"pixmaps").rmtree
    (prefix/"MacOS").rmtree
  end

  test do
    assert_equal "supertux2 v#{version}", shell_output("#{bin}/supertux2 --version").chomp
  end
end
