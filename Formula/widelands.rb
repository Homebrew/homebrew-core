class Widelands < Formula
  desc "Free real-time strategy game like Settlers II"
  homepage "https://www.widelands.org/"
  url "https://launchpad.net/widelands/build21/build21/+download/widelands-build21-source.tar.gz"
  version "21"
  sha256 "601e0e4c6f91b3fb0ece2cd1b83ecfb02344a1b9194fbb70ef3f70e06994e357"
  revision 5

  livecheck do
    url :stable
    regex(%r{<div class="version">\s*Latest version is [^<]*?v?(\d+(?:\.\d+)*)\s*</div>}i)
  end

  bottle do
    sha256 arm64_big_sur: "e9e36b1c26ef45a2bd8b450eac89105e465c6cedfec4b6b77422a246f9a37431"
    sha256 big_sur:       "05aa1e99267fc657793b9871ffbd34f0e4ec944920bac7fe8593328408246ecc"
    sha256 catalina:      "9933c7f6952274d3d65fab22c6f1e72d086dd2754207cf3d0b16da5f972aa2e1"
    sha256 mojave:        "fd14ec7e3b41d4607d31ccbdeaf44ed1f1826027ea29b8e25f2d9afdd62a1517"
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
