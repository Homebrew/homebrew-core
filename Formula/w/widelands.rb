class Widelands < Formula
  desc "Free real-time strategy game like Settlers II"
  homepage "https://www.widelands.org/"
  url "https://github.com/widelands/widelands/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "799bfd32048ef20118c48e21f3fc843ae0451c42bb8bf2eabcb9b26bf6fe54b4"
  license "GPL-2.0-or-later"
  version_scheme 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "8f6a42336d2463fa5fb780b1d0a265f58e83c8011f90b635a994b39fe2382c69"
    sha256 arm64_sonoma:  "f81d945d7bdb3961c2c808294496a42d29c78133850e6ff9578451c68524d043"
    sha256 arm64_ventura: "fde531ff4c5c0bd673dcefdc64caf3598b4c43fdc02b75a93464862054c7f96e"
    sha256 sonoma:        "506d22d26f4c3e2ab5893a116fbbb9a298073ac8fbb66ddb230874c495ff88a9"
    sha256 ventura:       "974a1506ca44d90f468e681ac4f29aed05fd0a2a3847b301600de2fd33c74cf2"
    sha256 x86_64_linux:  "68877518c427d75cf1a45005a2ee32258df2a587eadbfd6429af2626d90c51f7"
  end

  depends_on "asio" => :build
  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "gettext" => :build
  depends_on "pkgconf" => :build

  depends_on "glew"
  depends_on "icu4c@76"
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
