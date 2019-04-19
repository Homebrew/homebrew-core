class Widelands < Formula
  desc "Free real-time strategy game like Settlers II"
  homepage "https://wl.widelands.org/"
  url "https://launchpad.net/widelands/build19/build19/+download/widelands-build19-src.tar.bz2"
  sha256 "e511f9d26828a2b71b64cdfc6674e6e847543b2da73961ab882acca36c7c01a6"
  revision 15

  bottle do
    sha256 "034adfe29cec33aa07d10c3433e1d128f8451af4a207258b1b5b41d42fcd64da" => :mojave
    sha256 "0644d3786a52f1e66a6a0cd8e66f30f957cd6a06f9f8246f2089652a25f6a621" => :high_sierra
    sha256 "d6f7b94e79c7c7af14b724106dbdcc72047baf7631e9c8e76514d969f1dece23" => :sierra
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
