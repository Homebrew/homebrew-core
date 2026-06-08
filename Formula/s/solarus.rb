class Solarus < Formula
  desc "Action-RPG game engine"
  homepage "https://www.solarus-games.org/"
  url "https://gitlab.com/solarus-games/solarus.git",
      tag:      "v2.0.4",
      revision: "b942f8ce5c0562610a93079dcacf53a51fa88540"
  license "GPL-3.0-or-later"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_tahoe:   "b76a690587b54d9f03967cc96f2efc195eb394ebbf7daf8b6a8c04ae1136d156"
    sha256                               arm64_sequoia: "3b0e4aa0a5d17436c5401c49aa8ba45c362e46843eb4366f9ac4fbdd8ffad067"
    sha256                               arm64_sonoma:  "e0cea3781cca840a5a2028bba7bc54faceb3ce2f646428627e32a42463afb740"
    sha256                               sonoma:        "6fc0fd0b677a699281b508289b6d3ead8d76ae7209b3f3cf5ed81acac0beec48"
    sha256                               arm64_linux:   "2fbcca3c7cf963a0d7e09fdea04e9ea170429750ec8661cb44b8fece0ba255e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ad431b0d53d648f4d1f8e71322b2d2f9b40ead2fbae3721f52392be551b2352"
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
