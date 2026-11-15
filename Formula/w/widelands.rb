class Widelands < Formula
  desc "Free real-time strategy game like Settlers II"
  homepage "https://www.widelands.org/"
  url "https://github.com/widelands/widelands/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "e6f3e8f4fcafd367962dbacde80e26fc63afad38cfe26fadba9c92d4a01bd687"
  license "GPL-2.0-or-later"
  revision 1
  version_scheme 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_golden_gate: "63bb9b78af798e5415ed7679770a2c95c83eaa4218da323c12a8fc3c393b94ec"
    sha256 arm64_tahoe:       "fea3246a6ba975edd1ec470f45d44e468088404448672b8128bb3c63dcffee7a"
    sha256 arm64_sequoia:     "3ddc7c9038201cc9be0502efedce21028c32929ca18bf865f8a7e425f69df4df"
    sha256 arm64_linux:       "917d581731a5db0710ae57f03c5baec1ec24714e0ca91c98359e0dbb73d539ee"
    sha256 x86_64_linux:      "aa01863ac085aa98ab9f449980e5a58cc6325ac8adac6b3e567a5c0b6aee535f"
  end

  depends_on "asio" => :build
  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "gettext" => :build
  depends_on "pkgconf" => :build

  depends_on "glew"
  depends_on "icu4c@79"
  depends_on "libpng"
  depends_on "lua"
  depends_on "minizip"
  depends_on "sdl2-compat"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"
  depends_on "sdl2_ttf"

  uses_from_macos "python" => :build

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "mesa"
    depends_on "zlib-ng-compat"
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DWL_INSTALL_BASEDIR=#{pkgshare}",
                    "-DWL_INSTALL_BINDIR=#{bin}",
                    "-DWL_INSTALL_DATADIR=#{pkgshare}/data",
                    "-DOPTION_BUILD_CODECHECK=OFF",
                    "-DOPTION_BUILD_TESTS=OFF",
                    "-DOPTION_BUILD_WEBSITE_TOOLS=OFF",
                    "-DPYTHON_EXECUTABLE=#{which("python3")}",
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
