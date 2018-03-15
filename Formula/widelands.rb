class Widelands < Formula
  desc "Free real-time strategy game like Settlers II"
  homepage "https://wl.widelands.org/"
  url "https://launchpad.net/widelands/build19/build19/+download/widelands-build19-src.tar.bz2"
  sha256 "e511f9d26828a2b71b64cdfc6674e6e847543b2da73961ab882acca36c7c01a6"
  revision 8

  bottle do
    sha256 "18b34abd369e071601a35ab96e9b9776998f1f572ff638f50e79e9c9b6578397" => :high_sierra
    sha256 "2509f447f7be88a86602e239a0f711143a8438f9caccfcb1f0339c6583892869" => :sierra
    sha256 "552ff9433e4ea9b01e7b00372ce370cc1d0b0e3f98c21333498fd4da68c77d6d" => :el_capitan
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
