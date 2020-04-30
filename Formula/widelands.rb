class Widelands < Formula
  desc "Free real-time strategy game like Settlers II"
  homepage "https://www.widelands.org/"
  url "https://launchpad.net/widelands/build20/build20/+download/widelands-build20.tar.bz2"
  sha256 "38594d98c74f357d4c31dd8ee2b056bfe921f42935935af915d11b792677bcb2"
  revision 4

  bottle do
    sha256 "566e4df28ebad91fd302e08eee44f7187cc313c8f56f27013e332e31f3801f80" => :catalina
    sha256 "b57b2258ae8660dbadad79cd763011cdf084f994bd2c0c802b1a6921d5573329" => :mojave
    sha256 "533bb5c466c05abe0c4081effc159a5a31ecb30c1e2b5a06ea9cc86f6130271b" => :high_sierra
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
