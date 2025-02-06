class Sdl3 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https://www.libsdl.org/"
  url "https://github.com/libsdl-org/SDL/releases/download/release-3.2.0/SDL3-3.2.0.tar.gz"
  sha256 "bf308f92c5688b1479faf5cfe24af72f3cd4ce08d0c0670d6ce55bc2ec1e9a5e"
  license "Zlib"
  head "https://github.com/libsdl-org/SDL.git", branch: "main"

  livecheck do
    url :stable
    regex(/release[._-](\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cd0666d5f37a27cc66311756d868e971ec15a2573dc19240cb98d34a991f352d"
    sha256 cellar: :any,                 arm64_sonoma:  "3de7a53ffe85996d48f6f6704f3be9c88aa2a8692c51dcdddddc84f90b02bfb9"
    sha256 cellar: :any,                 arm64_ventura: "f0d9cb86ed4036a5c5da3008ce8dd76528c9c9f54e684c2c74e53067baf32a76"
    sha256 cellar: :any,                 sonoma:        "4339c70cd1dfde8b1d90d1bdee543715fcb9dacc60bbf69af9ec27623b7a7e79"
    sha256 cellar: :any,                 ventura:       "0442b21f126459a72f46e4f533b390a0970f3321ef2716d0a4c3f3947f863d4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eac5c83251c1d2dcdfcabe7c700465f865f675a51161205fd2e5e8acf6419b83"
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
