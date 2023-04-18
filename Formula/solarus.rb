class Solarus < Formula
  desc "Action-RPG game engine"
  homepage "https://www.solarus-games.org/"
  url "https://gitlab.com/solarus-games/solarus.git",
      tag:      "v1.6.5",
      revision: "3aec70b0556a8d7aed7903d1a3e4d9a18c5d1649"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "20fbf5ecc4020956d8d4938b8e02e0451030e504fe2f0a3493044b55e53763ef"
    sha256 cellar: :any,                 arm64_monterey: "1df04c516d36ec062f0ad18d10495aa879081a3564210dd264dd36e381410d23"
    sha256 cellar: :any,                 arm64_big_sur:  "1f9369c5a18363ef3c9fae788c8834f22e501b3edc69c9559747386107a058e3"
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
