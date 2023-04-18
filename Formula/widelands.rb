class Widelands < Formula
  desc "Free real-time strategy game like Settlers II"
  homepage "https://www.widelands.org/"
  url "https://github.com/widelands/widelands/archive/v1.0.tar.gz"
  sha256 "1dab0c4062873cc72c5e0558f9e9620b0ef185f1a78923a77c4ce5b9ed76031a"
  license "GPL-2.0-or-later"
  revision 3
  version_scheme 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "1e94d840cd45f42e169b1dcc7fbc2cc6983d61c892b94d5519f0729881bbf39c"
    sha256 arm64_monterey: "eac7f589d754177fd160e4371321577728dbcb7e719c4a7d4bc712b1ef81d009"
    sha256 arm64_big_sur:  "989add4d5adbe87440dbd28177d2e642227d2d77cf3873f708f623eb80db50a2"
    sha256 ventura:        "404bad3e0b03e2cd0da7ca93297733885eeec7fe7a93a47bb568b3e6e22c4c81"
    sha256 monterey:       "60a707dca605237f480f8250f71c39f190030c697176d01cf262b6c7a860447e"
    sha256 big_sur:        "c4401326c6726b6b7b710359536b965db788e74b2188efe927d2f2832ee86414"
    sha256 x86_64_linux:   "20a9dd41235119774e97af3460a153208766e94b30908fc6513309b0a5dd82d4"
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
