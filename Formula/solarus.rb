class Solarus < Formula
  desc "Action-RPG game engine"
  homepage "https://www.solarus-games.org/"
  url "https://gitlab.com/solarus-games/solarus.git",
      tag:      "v1.6.5",
      revision: "3aec70b0556a8d7aed7903d1a3e4d9a18c5d1649"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e02ef9bfa00c637a6e43e91eebdcb064a85465c72bfd2dbab0344512400bc614"
    sha256 cellar: :any,                 arm64_big_sur:  "f3b35b5252b2ee2c4068f7f4e2b952a1f88cbc9cacd4d84fb19680cea344bd7e"
    sha256 cellar: :any,                 monterey:       "820ab24962729c085bad240f89d02f7a313a33b0ed7a7fc67f6ddc02e07b030d"
    sha256 cellar: :any,                 big_sur:        "21eb9b511e6d49a1f17830ba8a7adcab4f0e3265c63f02679efba837ff77c55b"
    sha256 cellar: :any,                 catalina:       "819dc6f84e1b4e56ba679d8b798412b2a3f71350c0923cf340ab49e76075e202"
    sha256 cellar: :any,                 mojave:         "417dff62c280dd7e9bb742eef82fbae408a6e5fefcf427daf8d2af5955cc660a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c16e58513972223e10041e08fb72653fbc8ea1c7f85eb27d2aa4ae841e8183d"
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
    depends_on "openal-soft"
  end

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
