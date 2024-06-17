class Widelands < Formula
  desc "Free real-time strategy game like Settlers II"
  homepage "https://www.widelands.org/"
  url "https://github.com/widelands/widelands/archive/refs/tags/v1.2.tar.gz"
  sha256 "c6bed3717c541276fbed8a33adce230a2637297588c719268fcb963e076210e2"
  license "GPL-2.0-or-later"
  version_scheme 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "49df0bbc341c148bb09064dfdf41be0216f9c026e4cf78c803d5d58b15031028"
    sha256 arm64_ventura:  "5286091b56fb4c2bbd15841ac7074e07933bc75d4e1699d959e7da2eeabf5b45"
    sha256 arm64_monterey: "8b6883a14cd5732b4d71e423573a48da53f05329552f581775ac06ddb3f6bea5"
    sha256 sonoma:         "07ea532a734d18fbb7d1cb08ad4fad5c5c2c742ab25b28ba597c10af765d821c"
    sha256 ventura:        "8be55a2c96d0782a1195c0beae0221f52d52938af570835268fccc6339ffe205"
    sha256 monterey:       "18ad1a1c68b547c4a7079cd546b7d9f07f0a9a75a04eeb9d1f1a85dbf9eeb402"
    sha256 x86_64_linux:   "9cb4ef5b7a47e801e43e43c3b848fceaf2cdc510e94d9cbc00afc27bdcc4e518"
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
