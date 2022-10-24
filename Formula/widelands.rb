class Widelands < Formula
  desc "Free real-time strategy game like Settlers II"
  homepage "https://www.widelands.org/"
  url "https://github.com/widelands/widelands/archive/v1.1.tar.gz"
  sha256 "6853fcf3daec9b66005691e5bcb00326634baf0985ad89a7e6511502612f6412"
  version_scheme 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "2e16b0011802b992345db50c775930eda8d4556b3b8f412da7ea52810d4ebbea"
    sha256 arm64_big_sur:  "7697f542dff17d616555e5976968278dbd4ae49b1ed7cc0cdb05b5e87a2d50f4"
    sha256 monterey:       "3f7db3068889e5b705d520ab15bb3705474328d62e58febea3590a75ca3e9ccd"
    sha256 big_sur:        "175f7154f8371717603de77de6da9a5b421fd18fa6af3741edd7ac4a48b86cd0"
    sha256 catalina:       "202f69205c91984c0b7f6a9b134f996d431ad7334d834068aa78ea2b62555d81"
    sha256 x86_64_linux:   "1032792700cccdbaa04827dbc6849c309fa75d649f3253bd0c7568a1fd5d6770"
  end

  depends_on "asio" => :build
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

  uses_from_macos "python" => :build
  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    ENV.cxx11

    cmake_args = %W[
      -DOPTION_BUILD_WEBSITE_TOOLS=OFF
      -DOPTION_BUILD_TESTS=OFF
      -DCMAKE_INSTALL_PREFIX=#{prefix}
      -DWL_INSTALL_BASEDIR=#{pkgshare}
      -DWL_INSTALL_BINDIR=#{bin}
      -DWL_INSTALL_DATADIR=#{pkgshare}/data
      -DPNG_PNG_INCLUDE_DIR:PATH=#{Formula["libpng"].opt_include}
      -DPYTHON_EXECUTABLE=#{which("python3") || which("python")}
    ]

    system "cmake", "-S", ".", "-B", "build", *cmake_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    bin.write_exec_script prefix/"widelands"
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
