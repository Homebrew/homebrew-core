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
    sha256 arm64_big_sur: "71c4c90c5683047144f7dffc7bd98a517ce666f7993fd66c0c90d4c393f228c1"
    sha256 big_sur:       "e7709fb825d5d858b30249b295c24fc2472de28f94c9a647809569e9709bf046"
    sha256 catalina:      "3aaa4d406d614ceec36f37439e5b9c12e2782cb423012e8d65f27dbf90071688"
    sha256 mojave:        "aa235cbf6fc6c976731834dda095c7dbb792ac3a241de65dacf8f167d99b959e"
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
    on_linux do
      # Unable to start Widelands, because we were unable to add the home directory:
      # RealFSImpl::make_directory: No such file or directory: /tmp/widelands-test/.local/share/widelands
      mkdir_p ".local/share/widelands"
      mkdir_p ".config/widelands"
    end

    system bin/"widelands", "--version"
  end
end
