class Solarus < Formula
  desc "Action-RPG game engine"
  homepage "https://www.solarus-games.org/"
  url "https://gitlab.com/solarus-games/solarus.git",
      tag:      "v1.6.5",
      revision: "3aec70b0556a8d7aed7903d1a3e4d9a18c5d1649"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "81f2b618280f6e3c1c4301a33c110fc693ec2db3f077290101bc35794971ffa3"
    sha256 cellar: :any,                 arm64_big_sur:  "4fd02a38396ccef31a843c7d4172a1a8f3ba6e9f3573061433009922e08748ea"
    sha256 cellar: :any,                 monterey:       "7a515dbb5fc12783533f6f702696001bd9d948d71108eb17ffbc51da6cd69e84"
    sha256 cellar: :any,                 big_sur:        "7ef48a0cc8bf5a48ba41d78f0b2c950ded7e30dd53525e404d09af34f7df61cf"
    sha256 cellar: :any,                 catalina:       "58399ecdec97de696ec39a3eab21cb3fe7c6d3c08dab321c95bc2c4567192db5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "977c7794f247a875af1e24d9be7c82b76c42a5a12bc717be7b3ea8fff3d9764b"
  end

  depends_on "cmake" => :build
  depends_on "glm"
  depends_on "libmodplug"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "luajit-openresty"
  depends_on "physfs"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_ttf"

  on_linux do
    depends_on "gcc"
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
