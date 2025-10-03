class Sdl3 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https://libsdl.org/"
  url "https://github.com/libsdl-org/SDL/releases/download/release-3.2.24/SDL3-3.2.24.tar.gz"
  sha256 "81cc0fc17e5bf2c1754eeca9af9c47a76789ac5efdd165b3b91cbbe4b90bfb76"
  license "Zlib"
  head "https://github.com/libsdl-org/SDL.git", branch: "main"

  livecheck do
    url :stable
    regex(/release[._-](\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "93ecc626d5cb343d2695ba9c8a8fa27174c142ef34a0915acf942ef220de59fb"
    sha256 cellar: :any,                 arm64_sequoia: "19e49bd50dc7b3c42a908bfc8ab396bd8c434a879564bde5f714a7863a1ef8fc"
    sha256 cellar: :any,                 arm64_sonoma:  "3203016bc5ba85c8b569e6ffb8217a840756081629d72098847e077fc2746dd5"
    sha256 cellar: :any,                 sonoma:        "e40e900b071e714f62d9e76c0cb8ab4a2626176cc779176ecb4f131a4904be83"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b05a24f02366323c1286aced6ed17a38beaddd2a9582b4992d66b73e011ddc49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0656645e08fd5008709f1af176b378c550664fd2e14379d0b7b193fc39852ee8"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  on_linux do
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
