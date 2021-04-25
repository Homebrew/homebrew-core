class Widelands < Formula
  desc "Free real-time strategy game like Settlers II"
  homepage "https://www.widelands.org/"
  url "https://launchpad.net/widelands/build21/build21/+download/widelands-build21-source.tar.gz"
  version "21"
  sha256 "601e0e4c6f91b3fb0ece2cd1b83ecfb02344a1b9194fbb70ef3f70e06994e357"
  revision 7

  livecheck do
    url :stable
    regex(%r{<div class="version">\s*Latest version is [^<]*?v?(\d+(?:\.\d+)*)\s*</div>}i)
  end

  bottle do
    sha256 arm64_big_sur: "f37c6351a1d89ada0599d020bbe69939591e40288d0b59af8f83b17560c48b62"
    sha256 big_sur:       "60fe8cbb4cb9e21ad7b5dce4fb33c4b29dcd6c37cea53d747676fb537d5c0d44"
    sha256 catalina:      "673c7428f0a5e2e18f72d20cdd1cee05193f6a8fc854506880d393a5d3d652f4"
    sha256 mojave:        "92feabb99f4225ca9c82acad5a080695f648e5aa02157df70b1b2f38b66338a3"
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
