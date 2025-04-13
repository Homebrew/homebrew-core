class Widelands < Formula
  desc "Free real-time strategy game like Settlers II"
  homepage "https://www.widelands.org/"
  url "https://github.com/widelands/widelands/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "799bfd32048ef20118c48e21f3fc843ae0451c42bb8bf2eabcb9b26bf6fe54b4"
  license "GPL-2.0-or-later"
  revision 1
  version_scheme 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "4579bc3c41f00266fe1e3a50b4f23febf356ffe7e658becd1340a9c9fb9c2b9f"
    sha256 arm64_sonoma:  "d795ec6cfe18efe730a1ee729d28ce329f03905c5e476fa56d01545bbc324d86"
    sha256 arm64_ventura: "cc89f8628d9dbc446a7a5d4f65269eb2e720c4b0f69a922fc05f62532f8a2e04"
    sha256 sonoma:        "f6572c7feb4e4713414d27692883553a637aadf95ed03958f27a10bf5d0625fd"
    sha256 ventura:       "181a93b0acd13093356cf0d919a013dbe4ffc00019f8f3e6ae1772d5c5a24749"
    sha256 arm64_linux:   "6dc0a351fdca77d0ad76a78519f0582a2d452dabef0d20569daa98a420101585"
    sha256 x86_64_linux:  "f2d1782fc0592643d470a43c5f269bc3172e5faa05f9f83bf97e609cb6ef8e57"
  end

  depends_on "asio" => :build
  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "gettext" => :build
  depends_on "pkgconf" => :build

  depends_on "glew"
  depends_on "icu4c@77"
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

  on_linux do
    depends_on "mesa"
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
