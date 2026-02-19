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
    rebuild 1
    sha256 arm64_tahoe:   "4f2cbd089a6fe70dcbdbbb48ed3c36c0e6588d50b04ba7792865dbda6e539dc3"
    sha256 arm64_sequoia: "e896feb4c4cc20ea17f410588b4335652453941ac7d9548de4a900a07e3fb6f4"
    sha256 arm64_sonoma:  "dbfc14654014187e99ea8680689b27c74ccf067f9ad7b65011dc246a0f5d729b"
    sha256 sonoma:        "8c19bd1cf681931a78a0b8683ecd5002156ef343731df648de45ca7dbd74abe9"
    sha256 arm64_linux:   "5a1efa728ff06f26ead513c821c1a092c237ee1564ae5ce9491a3fb6d1c36642"
    sha256 x86_64_linux:  "ffa41e2bf59b3e7f5548bcd40b43b1a703d1ae58340027bed5f80e4994e7c6de"
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
