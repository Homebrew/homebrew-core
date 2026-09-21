class Solarus < Formula
  desc "Action-RPG game engine"
  homepage "https://www.solarus-games.org/"
  url "https://gitlab.com/solarus-games/solarus.git",
      tag:      "v2.1.4",
      revision: "29437e8a98263b1c9c2b742c39894a8eb6a2c200"
  license "GPL-3.0-or-later"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256               arm64_golden_gate: "e12c6b7fee97bb3cf9d461cff5b8640d4ff2f5fca027730b01a78f1dbae232cc"
    sha256               arm64_tahoe:       "1e8bd6f576c087d18c85dcd04a55423fa95d3dfa846b6d9311331b05f09d2983"
    sha256               arm64_sequoia:     "599a192269446b6ce0e392b90ff05017d8fb0a403e0fc9ce0f09075e29d25007"
    sha256               arm64_sonoma:      "904bd50a929085bdb11ebfcd7cb805a9f43be43cfb8875107b75925989943c69"
    sha256               arm64_linux:       "c4badd41b0328f4737f7e20fc3c74f946d58e8d663301f40956c60c57e29c89c"
    sha256 cellar: :any, x86_64_linux:      "94e23528ca5a411cdeb47695c23b74b1db8a9b39def7c3a5b1f47b3dc3982d60"
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
