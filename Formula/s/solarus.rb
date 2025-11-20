class Solarus < Formula
  desc "Action-RPG game engine"
  homepage "https://www.solarus-games.org/"
  url "https://gitlab.com/solarus-games/solarus.git",
      tag:      "v2.0.0",
      revision: "1c69f3d7ec133eaff28c22d756170eba69a520b0"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_tahoe:   "83cae14ca7357689da1572d95b375c5f1bb1dea3c8fa65b8ebdf105e3e354ca5"
    sha256                               arm64_sequoia: "85a7c6dfc13c8c421fa74d19b342a233cd44033cbf77cbb68ad09eaedc718dad"
    sha256                               arm64_sonoma:  "05499edb58e7a13a8967b7a6fbf809f51794cc5f53ce1495ee6bfe048a1bd2c1"
    sha256                               arm64_ventura: "010d2aa833ddfaa4bed2f231858589d37cf667b75e85bae1dbfed9e00cba7209"
    sha256                               sonoma:        "ef4bed02bcff7a4c5ef11bf7c2b8975a96e125b937f5326e3c45f52132563cb8"
    sha256                               ventura:       "83234601f53be7a2a3137671d73e94000b47316e77547332f066e70770469e20"
    sha256                               arm64_linux:   "c4bc34e892827477f7dc3c599df51d44e2b9f714bfda46c54e238e0d46e22923"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04d4e184b09908722468e977d425e4a1e441eb8dfe576d662445de67b659f73a"
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
