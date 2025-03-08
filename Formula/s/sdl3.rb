class Sdl3 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https://libsdl.org/"
  url "https://github.com/libsdl-org/SDL/releases/download/release-3.2.8/SDL3-3.2.8.tar.gz"
  sha256 "13388fabb361de768ecdf2b65e52bb27d1054cae6ccb6942ba926e378e00db03"
  license "Zlib"
  head "https://github.com/libsdl-org/SDL.git", branch: "main"

  livecheck do
    url :stable
    regex(/release[._-](\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c71af8f77a55f011dc9e429f7c86e87684aa761eceab80573de08351ddf542ec"
    sha256 cellar: :any,                 arm64_sonoma:  "134406f823bff2a05c29dcc1601c7613fda712044f595a91da8cd273c92ac1d3"
    sha256 cellar: :any,                 arm64_ventura: "6bef10281e5aa5d3114d878bc0fea150a63fa175e7f405eb39ddc5820078608a"
    sha256 cellar: :any,                 sonoma:        "8e6d1ae780225324b2bbc6c3ec73ed4bf872f2c5f7983bcb105992631078c950"
    sha256 cellar: :any,                 ventura:       "558864521f52c681fc5bdcab2f33ff870c19e4cd351187675589a9786bbf9c4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a17be1e3052d34c032df374e1161c2623848859f6f613fd3e2474d3747922a6a"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "libice"
    depends_on "libxcursor"
    depends_on "libxscrnsaver"
    depends_on "libxxf86vm"
    depends_on "pulseaudio"
    depends_on "xinput"
  end

  def install
    inreplace "cmake/sdl3.pc.in", "@SDL_PKGCONFIG_PREFIX@", HOMEBREW_PREFIX

    args = [
      "-DSDL_HIDAPI=ON",
      "-DSDL_WAYLAND=OFF",
    ]

    args += if OS.mac?
      ["-DSDL_X11=OFF"]
    else
      ["-DSDL_X11=ON", "-DSDL_PULSEAUDIO=ON"]
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~CPP
      #include <SDL3/SDL.h>
      int main() {
        if (SDL_Init(SDL_INIT_VIDEO) != 1) {
          return 1;
        }
        SDL_Quit();
        return 0;
      }
    CPP
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lSDL3", "-o", "test"
    ENV["SDL_VIDEODRIVER"] = "dummy"
    system "./test"
  end
end
