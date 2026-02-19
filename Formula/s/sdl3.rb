class Sdl3 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https://libsdl.org/"
  url "https://github.com/libsdl-org/SDL/releases/download/release-3.4.0/SDL3-3.4.0.tar.gz"
  sha256 "082cbf5f429e0d80820f68dc2b507a94d4cc1b4e70817b119bbb8ec6a69584b8"
  license "Zlib"
  head "https://github.com/libsdl-org/SDL.git", branch: "main"

  livecheck do
    url :stable
    regex(/release[._-](\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "58b0c63fad4075ac8bba7a5bc8039d371081bf5c02f649aff9a24dbc967524e7"
    sha256 cellar: :any,                 arm64_sequoia: "2cbb244ae0583b6760c40607d63cb6a53e7cfcdaa533455f7f7d6799458e5270"
    sha256 cellar: :any,                 arm64_sonoma:  "20c554ccc61b163cd2d87ebc58d726c5c51e31eae8edbb2c0d2b10c670b7353b"
    sha256 cellar: :any,                 sonoma:        "893eaab9be0aaa51c7f1f8fee114dcbeca7eb7d3f28e3c1734d68371edafb722"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91beaabeab0284e41bceaffe80fab5974afbe2da92eb24ab09d8c0faf6c07cfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbc7e8b732582c151217ec48c6bcdfe51d02b2819f3ac6fa1f19ff6432f3247a"
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
