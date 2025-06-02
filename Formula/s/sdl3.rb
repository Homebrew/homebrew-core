class Sdl3 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https://libsdl.org/"
  url "https://github.com/libsdl-org/SDL/releases/download/release-3.2.14/SDL3-3.2.14.tar.gz"
  sha256 "b7e7dc05011b88c69170fe18935487b2559276955e49113f8c1b6b72c9b79c1f"
  license "Zlib"
  head "https://github.com/libsdl-org/SDL.git", branch: "main"

  livecheck do
    url :stable
    regex(/release[._-](\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9fc5ea606986464d0e28043548aa6f28a49f2bebdfb3d8a5dcf51f16d5c8b89a"
    sha256 cellar: :any,                 arm64_sonoma:  "7fa6a3be9641557760354c61aab88b57990d6d2425d39522c0cb9514f01d3ba7"
    sha256 cellar: :any,                 arm64_ventura: "f276c456f68b1eb04d4dbfee90bbfcee71097abbdf73fc5dc7505e5a606eceab"
    sha256 cellar: :any,                 sonoma:        "218d0ee409437c58d02b2c5c30b04efbaaeddcdd2d10106c7ebd69924deb74e1"
    sha256 cellar: :any,                 ventura:       "88746e302f321a9990eb2e6a928857bbed7590d41ab21b2e61ce6d3130650c34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0323ce9d745c83a5e4575063997bf1a1a09b2a8ddd1099675b5f3ac5b3e5766f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48199501eca060fdd07ecaa14aa8036dcdbd0c476a3267426404f14da86e7659"
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
