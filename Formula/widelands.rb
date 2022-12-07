class Widelands < Formula
  desc "Free real-time strategy game like Settlers II"
  homepage "https://www.widelands.org/"
  url "https://github.com/widelands/widelands/archive/v1.0.tar.gz"
  sha256 "1dab0c4062873cc72c5e0558f9e9620b0ef185f1a78923a77c4ce5b9ed76031a"
  license "GPL-2.0-or-later"
  revision 2
  version_scheme 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "04e42710b9f9de4f78d5b6b52576790c767112af18c0b563a6d678c64c88a99e"
    sha256 arm64_monterey: "2e16b0011802b992345db50c775930eda8d4556b3b8f412da7ea52810d4ebbea"
    sha256 arm64_big_sur:  "7697f542dff17d616555e5976968278dbd4ae49b1ed7cc0cdb05b5e87a2d50f4"
    sha256 ventura:        "cda856f1b730de853b1bcf181b4720e5574cacb8096dd1fd7f3b25495a28e370"
    sha256 monterey:       "3f7db3068889e5b705d520ab15bb3705474328d62e58febea3590a75ca3e9ccd"
    sha256 big_sur:        "175f7154f8371717603de77de6da9a5b421fd18fa6af3741edd7ac4a48b86cd0"
    sha256 catalina:       "202f69205c91984c0b7f6a9b134f996d431ad7334d834068aa78ea2b62555d81"
    sha256 x86_64_linux:   "1032792700cccdbaa04827dbc6849c309fa75d649f3253bd0c7568a1fd5d6770"
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

  uses_from_macos "python" => :build
  uses_from_macos "curl"

  # Fix build with Boost 1.77+.
  # Remove with the next release (1.1).
  patch do
    url "https://github.com/widelands/widelands/commit/316eaea209754368a57f445ea4dd016ecf8eded6.patch?full_index=1"
    sha256 "358cae53bbc854e7e9248bdea0ca5af8bce51e188626a7f366bc6a87abd33dc9"
  end

  def install
    ENV.cxx11
    system "cmake", "-S", ".", "-B", "build",
                    # Without the following option, Cmake intend to use the library of MONO framework.
                    "-DPNG_PNG_INCLUDE_DIR:PATH=#{Formula["libpng"].opt_include}",
                    "-DWL_INSTALL_DATADIR=#{pkgshare}/data",
                    # older versions of macOS may not have `python3`
                    "-DPYTHON_EXECUTABLE=#{which("python3") || which("python")}",
                    *std_cmake_args
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
