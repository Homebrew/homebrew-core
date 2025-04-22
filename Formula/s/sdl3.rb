class Sdl3 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https://libsdl.org/"
  url "https://github.com/libsdl-org/SDL/releases/download/release-3.2.10/SDL3-3.2.10.tar.gz"
  sha256 "f87be7b4dec66db4098e9c167b2aa34e2ca10aeb5443bdde95ae03185ed513e0"
  license "Zlib"
  head "https://github.com/libsdl-org/SDL.git", branch: "main"

  livecheck do
    url :stable
    regex(/release[._-](\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c1140f4d49e47051e39ecac54b11421df8e968c91fc79407663480ec32174f81"
    sha256 cellar: :any,                 arm64_sonoma:  "8ce4e653cf80b81be8c89e38fcf3f63769a564862842c93e08a4247f58b9f67f"
    sha256 cellar: :any,                 arm64_ventura: "f098c3088281915716c3817182d9b16e689b392cb99a56c21641c9a6bd57311c"
    sha256 cellar: :any,                 sonoma:        "7630e295ae3fa74683604adb5ab5721e8fe57d01dc6ddbb18e9c5967817835f5"
    sha256 cellar: :any,                 ventura:       "ce4b4f0c4a98b867d870fe0044162da67b18672b8e869920753edf55d7aace8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a005cb5012f63caabab1bf2ffa4259d59366e270fa8f9e97b95f2d5509603990"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44901806d8ce301507288b8722c3bde5c5ad2cd6c7b89441ae5b6c2936e6f552"
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
