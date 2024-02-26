class Widelands < Formula
  desc "Free real-time strategy game like Settlers II"
  homepage "https://www.widelands.org/"
  url "https://github.com/widelands/widelands/archive/refs/tags/v1.1.tar.gz"
  sha256 "6853fcf3daec9b66005691e5bcb00326634baf0985ad89a7e6511502612f6412"
  license "GPL-2.0-or-later"
  revision 1
  version_scheme 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "0ac47acf86b2646cc1f020c0a6c482481f78eb03aa5e8ef7ca1902ec245978a0"
    sha256 arm64_ventura:  "3b0d1c2543c3c6d4529d7f44faabfb1ea2a95f173155962d3876c466e9a0a613"
    sha256 arm64_monterey: "30ed1d2fe00dd4f45f66d101ff0be92c2c8f6306d8df50082b4fd4fc09ca222a"
    sha256 sonoma:         "91a68cc33fece2d9213ac61e82ca72fab11873646fbe1fbe3108ce2861c16c9d"
    sha256 ventura:        "4282349d1de5a74bb211fc363042f6e9f8ab37324b31dfb9393da19b8ac2d074"
    sha256 monterey:       "ea2b0dcaaf82bb9c351246e6254ad28709b5a57cf0262f7464dcb5fddd659245"
    sha256 x86_64_linux:   "676ce11d380bc21483c452409a2d8a7f9508393068a26263ef251e43d26b63e1"
  end

  depends_on "asio" => :build
  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "gettext" => :build
  depends_on "pkg-config" => :build
  depends_on "glew"
  depends_on "icu4c"
  depends_on "libpng"
  depends_on "lua"
  depends_on "minizip"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"
  depends_on "sdl2_ttf"

  uses_from_macos "python" => :build
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DWL_INSTALL_BASEDIR=#{pkgshare}",
                    "-DWL_INSTALL_BINDIR=#{bin}",
                    "-DWL_INSTALL_DATADIR=#{pkgshare}/data",
                    "-DOPTION_BUILD_CODECHECK=OFF",
                    "-DOPTION_BUILD_TESTS=OFF",
                    "-DOPTION_BUILD_WEBSITE_TOOLS=OFF",
                    "-DPYTHON_EXECUTABLE=#{which("python3") || which("python")}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    if OS.linux?
      # Unable to start Widelands, because we were unable to add the home directory:
      # RealFSImpl::make_directory: No such file or directory: /tmp/widelands-test/.local/share/widelands
      mkdir_p ".local/share/widelands"
      mkdir_p ".config/widelands"
    end

    system bin/"widelands", "--version"
  end
end
