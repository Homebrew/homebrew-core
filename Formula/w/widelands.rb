class Widelands < Formula
  desc "Free real-time strategy game like Settlers II"
  homepage "https://www.widelands.org/"
  url "https://github.com/widelands/widelands/archive/refs/tags/v1.1.tar.gz"
  sha256 "6853fcf3daec9b66005691e5bcb00326634baf0985ad89a7e6511502612f6412"
  license "GPL-2.0-or-later"
  version_scheme 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "c0f1eb41f1ef1f6b359fb128e1ad3b0023532ab90188e7c8fd4843763f08b942"
    sha256 arm64_ventura:  "a5af48e0bb4984778e02feb82153bb26ffb340d69411bde7a76a7da63b512a77"
    sha256 arm64_monterey: "4390c9f4d380a0620b9111fef12dc43bb89f7d892524ebae56282254ef53477a"
    sha256 sonoma:         "1a1167910481b60ae611c2095c42b9a6be21cb89b330d918842abc42a3432a61"
    sha256 ventura:        "9580d60e79faaa491706b454e10a6c2be6ba016243d771251f491d8788615d1c"
    sha256 monterey:       "d0cb3c9a947a84a8faaef591a67f1c26132aa9858bb862b971a9b7f806f6d05a"
    sha256 x86_64_linux:   "aefc3bfe905cd517aa49229c59c19dc292f32decc8ef0d58fc91afa3631f42b5"
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
