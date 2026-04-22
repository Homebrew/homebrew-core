class Sdl3 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https://libsdl.org/"
  url "https://github.com/libsdl-org/SDL/releases/download/release-3.4.4/SDL3-3.4.4.tar.gz"
  sha256 "ee712dbe6a89bb140bbfc2ce72358fb5ee5cc2240abeabd54855012db30b3864"
  license "Zlib"
  compatibility_version 1
  head "https://github.com/libsdl-org/SDL.git", branch: "main"

  livecheck do
    url :stable
    regex(/release[._-](\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e755581de2dc4d285d7408cbdcd028786e86554f6b9ad1a39640a8684947a862"
    sha256 cellar: :any,                 arm64_sequoia: "f85fe79a52ebe9e384779ecfc30ddb9dcc80a300ac9c3c218c8857dc2c6a977c"
    sha256 cellar: :any,                 arm64_sonoma:  "557ed179eb9bb6c0c8b989d5614cf0029c3f7844444068569072f1416596ecb7"
    sha256 cellar: :any,                 sonoma:        "1d046b4f5c731870ce735c69614c84585753ddd3e0bcf328bff98ec30a7aaaef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b20d983b09b1f6e065837f9d5d8a746d10c6cd443c6e5442e013a7cec1e1b592"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "752ae1ed99c939e1888fc616f0209d3376389d3d27afb62afeb8a081c74a9ed5"
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
