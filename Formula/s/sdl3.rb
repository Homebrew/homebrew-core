class Sdl3 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https://libsdl.org/"
  url "https://github.com/libsdl-org/SDL/releases/download/release-3.4.2/SDL3-3.4.2.tar.gz"
  sha256 "ef39a2e3f9a8a78296c40da701967dd1b0d0d6e267e483863ce70f8a03b4050c"
  license "Zlib"
  head "https://github.com/libsdl-org/SDL.git", branch: "main"

  livecheck do
    url :stable
    regex(/release[._-](\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b941840dd9cf51e809caace7b82226c9c0733b50bb5e9672cff9d66bcf7aa145"
    sha256 cellar: :any,                 arm64_sequoia: "72b0114451067003c6ad857b4a462f303f24ef756d2e01d6b6872421635d6a47"
    sha256 cellar: :any,                 arm64_sonoma:  "bc23a37e5bd9af3fdd6fa958294d9579b5000ab9702a992332c4a2acf40edf38"
    sha256 cellar: :any,                 sonoma:        "7691c5be02726b18dddd7ce5b4a866248eafeb1cdd8b5627f26d1c1a32cee753"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f21a84f5266c61587b23c5bb238fe5d952419062e0f81f22ac5a42c0b13b31ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7d16d1f21eb263ae96fe3afe6958b96d2e951ad2a288d0e7735561206ecb7f7"
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
