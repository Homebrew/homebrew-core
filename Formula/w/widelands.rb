class Widelands < Formula
  desc "Free real-time strategy game like Settlers II"
  homepage "https://www.widelands.org/"
  url "https://github.com/widelands/widelands/archive/refs/tags/v1.3.tar.gz"
  sha256 "8468b6bc0ddb70749c09c5603109ceeb79b95f3602d3aa55ecfad84f8ea82571"
  license "GPL-2.0-or-later"
  revision 1
  version_scheme 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "3a62a862ea1cf6d5f34619afd4c0b80b0ef433848ded0d103af4bb24b302fbcb"
    sha256 arm64_sequoia: "0dc37d35152b9d92f8b2a1989e5d83a8d7c15456f070390e720b25396a6cca57"
    sha256 arm64_sonoma:  "a671a12752fb6378b4afcf4609f8b80301f24c6bb0a32c6b69c8e836e4f935c7"
    sha256 sonoma:        "e75054b0b228da298b0f20e2c513caa9cbd25504e186c57f637d2c21544727cf"
    sha256 arm64_linux:   "e1e5ad56b87f7e520ab0ecb4eabc565cbe772e4ea1042eb927a26e7fbea3484b"
    sha256 x86_64_linux:  "b9c9ed74ec42f56a34fe2fd7a75f28e7877c9ca4d27c17f9d69d856a2391aec2"
  end

  depends_on "asio" => :build
  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "gettext" => :build
  depends_on "pkgconf" => :build

  depends_on "glew"
  depends_on "icu4c@78"
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
