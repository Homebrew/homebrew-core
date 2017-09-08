class Widelands < Formula
  desc "Free real-time strategy game like Settlers II."
  homepage "https://wl.widelands.org/"
  url "https://launchpad.net/widelands/build19/build19/+download/widelands-build19-src.tar.bz2"
  sha256 "e511f9d26828a2b71b64cdfc6674e6e847543b2da73961ab882acca36c7c01a6"
  revision 5

  bottle do
    sha256 "26320006eefd40e195403347a08e71b4c26dc5191c832492f7171c7e14917a00" => :sierra
    sha256 "c4698f6e230041cbed349646031c360d15ac3dd345b9bfd10da569a80aac9917" => :el_capitan
    sha256 "3022d10e1c634921acc48295c83b75f3983ae2b2e7e20dcb13c9255510a20187" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "libpng"
  depends_on "minizip"
  depends_on "gettext"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"
  depends_on "sdl2_net"
  depends_on "sdl2_ttf"
  depends_on "doxygen"
  depends_on "glew"
  depends_on "lua"
  depends_on "icu4c"

  needs :cxx11

  def install
    ENV.cxx11
    mkdir "build" do
      system "cmake", "..",
                      # Without the following option, Cmake intend to use the library of MONO framework.
                      "-DPNG_PNG_INCLUDE_DIR:PATH=#{Formula["libpng"].opt_include}",
                      "-DWL_INSTALL_DATADIR=#{pkgshare}/data",
                       *std_cmake_args
      system "make", "install"

      (bin/"widelands").write <<-EOS.undent
        #!/bin/sh
        exec #{prefix}/widelands "$@"
      EOS
    end
  end

  test do
    system bin/"widelands", "--version"
  end
end
