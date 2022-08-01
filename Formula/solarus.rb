class Solarus < Formula
  desc "Action-RPG game engine"
  homepage "https://www.solarus-games.org/"
  url "https://gitlab.com/solarus-games/solarus.git",
      tag:      "v1.6.5",
      revision: "3aec70b0556a8d7aed7903d1a3e4d9a18c5d1649"
  license "GPL-3.0-or-later"
  revision 2

  # Linux bottle removed for GCC 12 migration
  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2ae97a8f18bee5115f7f801ec8a8b31d6ad6ba98491402084432b954406af8aa"
    sha256 cellar: :any,                 arm64_big_sur:  "f88cd9f0a9883baa813108017034bdb54dd4d5ae8c1c651fd2a0bb23076896d6"
    sha256 cellar: :any,                 monterey:       "979da74628804c8e2517ffd5ee1dd97331d8b88f9148ecb6943db3985a574bfe"
    sha256 cellar: :any,                 big_sur:        "e134a16e60f8b9c9aeedc4824acba770e01c70ca5ddbf623a87b112bd708757e"
    sha256 cellar: :any,                 catalina:       "2ca4689984b74144664fc5e620df94ac3b1bbece2ab8ad0a2641fad3aba07880"
  end

  depends_on "cmake" => :build
  depends_on "glm"
  depends_on "libmodplug"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "luajit"
  depends_on "physfs"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_ttf"

  on_linux do
    depends_on "mesa"
    depends_on "openal-soft"
  end

  fails_with gcc: "5" # needs same GLIBCXX as mesa at runtime

  def install
    ENV.append_to_cflags "-I#{Formula["glm"].opt_include}"
    ENV.append_to_cflags "-I#{Formula["physfs"].opt_include}"
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DSOLARUS_ARCH=#{Hardware::CPU.arch}",
                    "-DSOLARUS_GUI=OFF",
                    "-DSOLARUS_TESTS=OFF",
                    "-DVORBISFILE_INCLUDE_DIR=#{Formula["libvorbis"].opt_include}",
                    "-DOGG_INCLUDE_DIR=#{Formula["libogg"].opt_include}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{bin}/solarus-run", "-help"
  end
end
