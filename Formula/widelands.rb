class Widelands < Formula
  desc "Free real-time strategy game like Settlers II"
  homepage "https://www.widelands.org/"
  url "https://launchpad.net/widelands/build20/build20/+download/widelands-build20.tar.bz2"
  sha256 "38594d98c74f357d4c31dd8ee2b056bfe921f42935935af915d11b792677bcb2"

  bottle do
    sha256 "c6c4f61af7e80fd92a7f5ef4e256f4395d120ded75d9561963bed95ebfde0dce" => :mojave
    sha256 "ecde85649672221e585089e486cad24ebef02d0c16b43ae19cfbfc9c4f955385" => :high_sierra
    sha256 "334cf2637614e32d9d3f6c49b1350d3266a81784329979283c9b057cbc50c49b" => :sierra
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
