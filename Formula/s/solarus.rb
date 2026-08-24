class Solarus < Formula
  desc "Action-RPG game engine"
  homepage "https://www.solarus-games.org/"
  url "https://gitlab.com/solarus-games/solarus.git",
      tag:      "v2.1.3",
      revision: "72d81668d6902b99338bbe1926a7d048ec1d3476"
  license "GPL-3.0-or-later"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256               arm64_tahoe:   "6a0d998953da608000d3ce73425fa7550f7ea2736ddd44d9332bb99eb18d68e9"
    sha256               arm64_sequoia: "6005a573f11a29f5f9b0af9e39998490a961b7993e422510d9f42f58d5c2fc40"
    sha256               arm64_sonoma:  "b03d148074cf8c445ed744c5774b994e804dd67b037c3a46d3cf76edade8100b"
    sha256               sonoma:        "6781f92423bb06702a743f1842c5110833ef0e2012a5139ff011fcf0f94ebba8"
    sha256               arm64_linux:   "3b5aafa521d0c4ff29951141c8099ffa4fb6ad664f0a96a3a8c1591d005e872a"
    sha256 cellar: :any, x86_64_linux:  "f13ea46007ba8bae769fa3d7116fc462d26e71372e4265e7cdce9e57dd32e777"
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
