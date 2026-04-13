class Widelands < Formula
  desc "Free real-time strategy game like Settlers II"
  homepage "https://www.widelands.org/"
  url "https://github.com/widelands/widelands/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "e6f3e8f4fcafd367962dbacde80e26fc63afad38cfe26fadba9c92d4a01bd687"
  license "GPL-2.0-or-later"
  version_scheme 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "e61c9fed2f752bd87cfae05918936c9c14f34cf1c23d2ebe42d7d858cb57a70a"
    sha256 arm64_sequoia: "7e17bf998e0c713eb41e7431d04d1934e9e13072ae8e015940c38305ec54c5b6"
    sha256 arm64_sonoma:  "2b1b4a6c64156b8b5b74031e165a71eb386877ba7b962376b59b6152a5ca3a73"
    sha256 sonoma:        "36eb4c3ee035cebae44213d5c6a76a57b13714c47b70f6aaea44f46badf00295"
    sha256 arm64_linux:   "5d0a8eb18082b2e40898313d7c83f94e06e33c9587037a10ff74130e476847d5"
    sha256 x86_64_linux:  "eced0f3c4f891673c94286a75b9cf31fdcacc2a370db7045b9983f48ba960bc7"
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
