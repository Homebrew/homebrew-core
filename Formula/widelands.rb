class Widelands < Formula
  desc "Free real-time strategy game like Settlers II"
  homepage "https://www.widelands.org/"
  url "https://launchpad.net/widelands/build20/build20/+download/widelands-build20.tar.bz2"
  sha256 "38594d98c74f357d4c31dd8ee2b056bfe921f42935935af915d11b792677bcb2"

  bottle do
    sha256 "767eaff867480bb4c46a058ef496f7a95db60ce76e1c834d94355c1347ea82d0" => :mojave
    sha256 "59a4e1002c6ff42326febad081428ca17323c38acb433433b715af3a0d5b817a" => :high_sierra
    sha256 "38b7a80a82fa1a50d2458c5434909480b636db991a65d001ab2130793ffad991" => :sierra
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
