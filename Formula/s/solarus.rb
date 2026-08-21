class Solarus < Formula
  desc "Action-RPG game engine"
  homepage "https://www.solarus-games.org/"
  url "https://gitlab.com/solarus-games/solarus.git",
      tag:      "v2.1.2",
      revision: "1c7c19a9a22253fa0a87274acb847b2b8be18dae"
  license "GPL-3.0-or-later"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256               arm64_tahoe:   "84b168f6268422550c924f40ef0bbcc47ccd7567f02d7a3a5ef5d0eed3683a68"
    sha256               arm64_sequoia: "ae6d7dc99aa65b0b8796693b4ba36bfd5aaf7ef1e434cf35e6f4760721aa7187"
    sha256               arm64_sonoma:  "48009d28ad5b595361d5462e2f332e06bcd26b439559dca32d7ab35ec6b7d902"
    sha256               sonoma:        "f9ae5979ed30bbbb71aa5db671e78fde6b23417cbceafd16e8c285c87dea6981"
    sha256               arm64_linux:   "850cd1cbb3e49d6a078418e83c4198ee6d4e39a2b5245228b5bcc8de56b23b1d"
    sha256 cellar: :any, x86_64_linux:  "fe6da57384e806bdf8e67a991432ccc618d56beb71869338b1ef64aede43f7fe"
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
  depends_on "sdl2-compat"
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
                    "-DVORBISFILE_INCLUDE_DIR=#{formula_opt_include("libvorbis")}",
                    "-DOGG_INCLUDE_DIR=#{formula_opt_include("libogg")}",
                    "-DGLM_INCLUDE_DIR=#{formula_opt_include("glm")}",
                    "-DPHYSFS_INCLUDE_DIR=#{formula_opt_include("physfs")}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"solarus-run", "-help"
  end
end
