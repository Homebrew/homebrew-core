class Widelands < Formula
  desc "Free real-time strategy game like Settlers II"
  homepage "https://www.widelands.org/"
  url "https://github.com/widelands/widelands/archive/refs/tags/v1.2.tar.gz"
  sha256 "c6bed3717c541276fbed8a33adce230a2637297588c719268fcb963e076210e2"
  license "GPL-2.0-or-later"
  revision 1
  version_scheme 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "ef5011b7b2949d380e2793bd2805d64ae6df4ff121cbbc0a527832e517ee04f2"
    sha256 arm64_sonoma:  "433046161980ec43882054adfe81d69b7a66be689816608d6436b027192af261"
    sha256 arm64_ventura: "0c55b3ec21a434d72e4752b5da90111de2c9bf0118ea049221e30d538a84f224"
    sha256 sonoma:        "ff50e8ef45cae5c807fc27267fbcb133b010cfa8c7acf1bb493fed0efa91cebe"
    sha256 ventura:       "c629a2736fc3437abb528a9de87794edc8afb3fc22a4e0071322385ac2a601ad"
    sha256 x86_64_linux:  "7664648dc80ec5a0d70fa674628244f8a652b1e326f1f1ee03b7187570f43169"
  end

  depends_on "asio" => :build
  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "gettext" => :build
  depends_on "pkg-config" => :build

  depends_on "glew"
  depends_on "icu4c@75"
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
