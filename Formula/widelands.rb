class Widelands < Formula
  desc "Free real-time strategy game like Settlers II"
  homepage "https://www.widelands.org/"
  url "https://launchpad.net/widelands/build20/build20/+download/widelands-build20.tar.bz2"
  sha256 "38594d98c74f357d4c31dd8ee2b056bfe921f42935935af915d11b792677bcb2"
  revision 2

  bottle do
    rebuild 1
    sha256 "0591b9c236d9fca0ef0106fe4d9e1ed052f132cd9ed6b1f91053193de7ec69f0" => :catalina
    sha256 "1e9f5c6ffbce0a770d3fdfc89c58a52b0467df58fad30ad7e798c88df77b0839" => :mojave
    sha256 "9cd635721afd65d46a7d8667838ab8737ebc641cf9aef8d3ed96a9ed501dcdfb" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "doxygen"
  depends_on "gettext"
  depends_on "glew"
  depends_on "icu4c"
  depends_on "libpng"
  depends_on "lua"
  depends_on "minizip"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"
  depends_on "sdl2_ttf"

  def install
    ENV.cxx11
    mkdir "build" do
      system "cmake", "..",
                      # Without the following option, Cmake intend to use the library of MONO framework.
                      "-DPNG_PNG_INCLUDE_DIR:PATH=#{Formula["libpng"].opt_include}",
                      "-DWL_INSTALL_DATADIR=#{pkgshare}/data",
                       *std_cmake_args
      system "make", "install"

      (bin/"widelands").write <<~EOS
        #!/bin/sh
        exec #{prefix}/widelands "$@"
      EOS
    end
  end

  test do
    system bin/"widelands", "--version"
  end
end
