class Sdl3 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https://libsdl.org/"
  url "https://github.com/libsdl-org/SDL/releases/download/release-3.4.8/SDL3-3.4.8.tar.gz"
  sha256 "e9fff7467fb60f037e6708da18b25560649e4c63edc2a69bb871b960d9cbfbba"
  license "Zlib"
  compatibility_version 1
  head "https://github.com/libsdl-org/SDL.git", branch: "main"

  livecheck do
    url :stable
    regex(/release[._-](\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bce5819cd3a60a531e67a2ed1ff6f06cb426ec39a6ed132cfe8aa84e7ffff18f"
    sha256 cellar: :any,                 arm64_sequoia: "c5dce093f69b0fd4160a731d9eb075654da079799d308d9111ea8720cd9c6c5a"
    sha256 cellar: :any,                 arm64_sonoma:  "1b9171d0c23eff375f5af894d4bdc82b2769434b68c8c748d64640bd706f9909"
    sha256 cellar: :any,                 sonoma:        "9ea79e01741cb4cac9ee900ecc7ef58098d878a639581fe926b5170ef1f259b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3cd8b8d8110b071f8aba22624b00047e4178904bfb98456a389a12bf34aec0a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "387593990db38c1a1b92691da7ccd586b770926eed5b8dc18807cfa20e1af742"
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

    args = %w[
      -DSDL_HIDAPI=ON
      -DSDL_WAYLAND=OFF
      -DSDL_X11_XTEST=OFF
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
