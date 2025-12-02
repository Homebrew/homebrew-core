class Widelands < Formula
  desc "Free real-time strategy game like Settlers II"
  homepage "https://www.widelands.org/"
  url "https://github.com/widelands/widelands/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "799bfd32048ef20118c48e21f3fc843ae0451c42bb8bf2eabcb9b26bf6fe54b4"
  license "GPL-2.0-or-later"
  revision 2
  version_scheme 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "2e93a441e258d920fffae7b0a0a009965eb49c4e775d65e50591af211786376a"
    sha256 arm64_sequoia: "52ea992bb1eefb72d352bb73ae3de85042a5489d9b5330fd319ecec53e8a8f0f"
    sha256 arm64_sonoma:  "1bcf79335668fad8e45389a492587b718f87d240fac8300ca6974f6b3ec07fa2"
    sha256 sonoma:        "78aec7c4d000504fea9fe879aa4cec3d6661cd051537f90eacc9fe9957cf6bfc"
    sha256 arm64_linux:   "abb750a955e4afcc7c7820c822920c79f90db4328cbcfaacd152a236ba85de39"
    sha256 x86_64_linux:  "efca73a2fd0fbb0ec46951eccf835bad7ffd0b47d3f3dee959d1229b069b46ea"
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

  # Backport fix for newer asio
  patch do
    url "https://github.com/widelands/widelands/commit/c0b44ccc04df35a9a23ca9be3e05f5d3a5428f6f.patch?full_index=1"
    sha256 "8db8447ab83e10031e0903cc0accec962f30f5b9fa31a8ce68db788efa7756b4"
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
