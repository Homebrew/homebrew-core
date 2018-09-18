class Widelands < Formula
  desc "Free real-time strategy game like Settlers II"
  homepage "https://wl.widelands.org/"
  url "https://launchpad.net/widelands/build19/build19/+download/widelands-build19-src.tar.bz2"
  sha256 "e511f9d26828a2b71b64cdfc6674e6e847543b2da73961ab882acca36c7c01a6"
  revision 11

  bottle do
    sha256 "43e42b0992062b533fcd329b1a54182e23efbefdcef94ac9c8a1e9943c3de682" => :mojave
    sha256 "145386353807d7475c91a805a6024a844e5326116ede9195f98d717f5933bdcd" => :high_sierra
    sha256 "fe7fb90d75ea8e8f190860d4c5aed75f3cd4bf03b5b8d07e68ddb60d1c8b9422" => :sierra
    sha256 "4e3859c9f2025e83216237ebf326cb2d6baf658d950e51bb7d80ce2fc2827ac7" => :el_capitan
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
  depends_on "sdl2_net"
  depends_on "sdl2_ttf"

  needs :cxx11

  def install
    # icu4c 61.1 compatability
    ENV.append "CXXFLAGS", "-DU_USING_ICU_NAMESPACE=1"

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
