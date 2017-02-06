class Widelands < Formula
  desc "Free real-time strategy game like Settlers II."
  homepage "https://wl.widelands.org/"
  url "https://launchpad.net/widelands/build19/build19/+download/widelands-build19-src.tar.bz2"
  sha256 "e511f9d26828a2b71b64cdfc6674e6e847543b2da73961ab882acca36c7c01a6"

  bottle do
    sha256 "95963abfc0247618837dc467a638ccfd69b2b47785a0608f2ae60fc2662ec258" => :sierra
    sha256 "cb42054b619f17310fdcc20f8b8d23dd449771b813223e7e998c7973edea39b4" => :el_capitan
    sha256 "2f7fc6715fbc40b5acd6fb55630f44f76d4838487e6a5f2ceaa230de05aece26" => :yosemite
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
