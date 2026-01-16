class Solarus < Formula
  desc "Action-RPG game engine"
  homepage "https://www.solarus-games.org/"
  url "https://gitlab.com/solarus-games/solarus.git",
      tag:      "v2.0.2",
      revision: "0874ea9df1bb73aa7d9c43763916805100dfc524"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_tahoe:   "aabe080c5a9ec9abfd98401587bf08fa7735a80688a0be8b29f1c90f21b42eea"
    sha256                               arm64_sequoia: "70399e45d5a8ee62c9ea4bb80b5d0ae52f052255dc89e7f65f1c7a5aca98fa63"
    sha256                               arm64_sonoma:  "1121cf72c5321a12d5bfe33633b98e0b2b50054004a84bc3132477aabb644f4a"
    sha256                               sonoma:        "7a8bb414a2c115728548f742f56960731f82665c267c26cedf6c8b7699c31809"
    sha256                               arm64_linux:   "90f5ed0ea3e76d79c39173d41656362a5af72f270a91a172de0961aed6dcc478"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e10498da498c99b1f5d2870de0e6b9f5381b6894ef3e943ad4c7fab1b7edd27"
  end

  depends_on "cmake" => :build
  depends_on "glm"
  depends_on "libmodplug"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "luajit"
  # Upstream only supports OpenAL Soft and not macOS OpenAL.framework
  # https://gitlab.com/solarus-games/solarus/-/blob/dev/cmake/modules/FindOpenAL.cmake?ref_type=heads#L38
  depends_on "openal-soft"
  depends_on "physfs"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_ttf"

  on_linux do
    depends_on "mesa"
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DSOLARUS_ARCH=#{Hardware::CPU.arch}",
                    "-DSOLARUS_GUI=OFF",
                    "-DSOLARUS_TESTS=OFF",
                    "-DVORBISFILE_INCLUDE_DIR=#{Formula["libvorbis"].opt_include}",
                    "-DOGG_INCLUDE_DIR=#{Formula["libogg"].opt_include}",
                    "-DGLM_INCLUDE_DIR=#{Formula["glm"].opt_include}",
                    "-DPHYSFS_INCLUDE_DIR=#{Formula["physfs"].opt_include}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"solarus-run", "-help"
  end
end
