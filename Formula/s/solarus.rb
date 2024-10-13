class Solarus < Formula
  desc "Action-RPG game engine"
  homepage "https://www.solarus-games.org/"
  url "https://gitlab.com/solarus-games/solarus.git",
      tag:      "v1.6.5",
      revision: "3aec70b0556a8d7aed7903d1a3e4d9a18c5d1649"
  license "GPL-3.0-or-later"
  revision 2

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "7a1ba3cba1fb09278c607e4a5864dcd8d71d7ec44b43835661185195d3b23c24"
    sha256 cellar: :any,                 arm64_sonoma:   "f26e691c890948a299006ddc3677442e381252d77ba46efb5685e0215600a515"
    sha256 cellar: :any,                 arm64_ventura:  "20fbf5ecc4020956d8d4938b8e02e0451030e504fe2f0a3493044b55e53763ef"
    sha256 cellar: :any,                 arm64_monterey: "1df04c516d36ec062f0ad18d10495aa879081a3564210dd264dd36e381410d23"
    sha256 cellar: :any,                 arm64_big_sur:  "1f9369c5a18363ef3c9fae788c8834f22e501b3edc69c9559747386107a058e3"
    sha256 cellar: :any,                 sonoma:         "7ca49a0c4ce7d2ce720eec066d4058946e663d147d5a429e96fb0cecfdd1bb43"
    sha256 cellar: :any,                 ventura:        "16c9bbe34ef0d45488c4406b2a94182784281810f54682dc5b08781476b2fbdb"
    sha256 cellar: :any,                 monterey:       "6c33e0972e80bac278d3d4e2b2584032a20ca92256231b27c99fb9cb1ab61bb8"
    sha256 cellar: :any,                 big_sur:        "a0c0902c8ec2ee91d806ac6f65526c76478cae5309dd335ef4fb47ef8d98b651"
    sha256 cellar: :any,                 catalina:       "a2e50fcb5ead429c8f72c5a484dc45d1089f94f6d2e58420c9fd544057516226"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08b76ceebc80b02c8ae22dadf8d4b0f22827e8dca8254567951669575360c20f"
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

  # Backport fix for error: GLM: GLM_GTX_matrix_transform_2d is an experimental extension
  patch do
    url "https://gitlab.com/solarus-games/solarus/-/commit/2200e0ccc8e2850d2a265cace96c3f548d988f2d.diff"
    sha256 "dee33b7f334be09d358b1c6534d3230cb66038095f9d77f87d9bc285082f6393"
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
