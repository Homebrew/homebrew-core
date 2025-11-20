class Sdl3 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https://libsdl.org/"
  url "https://github.com/libsdl-org/SDL/releases/download/release-3.2.26/SDL3-3.2.26.tar.gz"
  sha256 "dad488474a51a0b01d547cd2834893d6299328d2e30f479a3564088b5476bae2"
  license "Zlib"
  head "https://github.com/libsdl-org/SDL.git", branch: "main"

  livecheck do
    url :stable
    regex(/release[._-](\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "db62e8019c8c59a99fd5098dbdec327966b8c05e092bbd47a1a280885f44f4c2"
    sha256 cellar: :any,                 arm64_sequoia: "f1b9e86f673222818d1fa6dcc712d2b0a43e20b53cc15b73d9f3283cd9c14290"
    sha256 cellar: :any,                 arm64_sonoma:  "0272ee284d41de8d2455d30352c0e5ddfb43c2f78e976764763efb66dfa8fc1f"
    sha256 cellar: :any,                 sonoma:        "8b8437f11d44c7069e184f42acaf9d2c39572ae48679d42ee8669d86c1b0d0a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e5a2cef18ffa3003503b88cded5a9c210660fc3209610d7c121ba5208dfc239"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48e78955e0a3f763ae67913d9c49d80e75620bdb12fb81500950a837b86e2b09"
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
