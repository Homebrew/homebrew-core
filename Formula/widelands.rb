class Widelands < Formula
  desc "Free real-time strategy game like Settlers II"
  homepage "https://wl.widelands.org/"
  url "https://launchpad.net/widelands/build19/build19/+download/widelands-build19-src.tar.bz2"
  sha256 "e511f9d26828a2b71b64cdfc6674e6e847543b2da73961ab882acca36c7c01a6"
  revision 6

  bottle do
    sha256 "9e3bea1677c7aadd41dfcb4a1e524277bbf8e8a2ea8f9318d15cc67f78c0871f" => :high_sierra
    sha256 "bdca6516a0b76f3d03f7ea7600c566cc55a08c9b6616abddff19d22ae1ac2e5c" => :sierra
    sha256 "344c11b8553f0231c3ee6cd20ee951f1b6b0b141e82c544e57e083aab7ef5a38" => :el_capitan
    sha256 "96f8d5f417679eb8f35dbd26325590a6833515608596febb9942d3be988ddefc" => :yosemite
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
