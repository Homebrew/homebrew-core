class Solarus < Formula
  desc "Action-RPG game engine"
  homepage "https://www.solarus-games.org/"
  url "https://gitlab.com/solarus-games/solarus.git",
      tag:      "v2.0.3",
      revision: "d5e170be67a0119d73a502988e91bffcf04c3e06"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_tahoe:   "4fd142b272d98d79ac590c1723f8719583d14288491f7293de89bdc2f1117883"
    sha256                               arm64_sequoia: "8d5cb7264269abe15846627ed30fdd162fb4d768b88cd92f0f56d3faa6c5ea7a"
    sha256                               arm64_sonoma:  "d669556017aba8337727e74ba0af5846bfddcabc06ba56e011b83f4548984d2d"
    sha256                               sonoma:        "a88bc9b75edb70e32c2eeeb8406222e7d228fa5c1cbf9c41707de427b2a88449"
    sha256                               arm64_linux:   "eea3bd59dce92c3d7186f3657fc3f0483f2ea7710d1463faa2d46c184a20df5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21cb7e8faea567a0e086e689d070f2faabb7a8cc61008e9a73add92df30e09b3"
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
