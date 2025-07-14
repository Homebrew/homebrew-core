class Sdl3 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https://libsdl.org/"
  url "https://github.com/libsdl-org/SDL/releases/download/release-3.2.16/SDL3-3.2.16.tar.gz"
  sha256 "6340e58879b2d15830c8460d2f589a385c444d1faa2a4828a9626c7322562be8"
  license "Zlib"
  head "https://github.com/libsdl-org/SDL.git", branch: "main"

  livecheck do
    url :stable
    regex(/release[._-](\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1c67df52a37bbd4f13f61eca7c19bea36a53ff3dc0d310c9a878cd0f924edb21"
    sha256 cellar: :any,                 arm64_sonoma:  "85d25691ab5555af9cdc272551be6564bc0b460f57b2eae7effb6f6f044c2061"
    sha256 cellar: :any,                 arm64_ventura: "abf021c48b6276686d35220f7288635fca53b0bec6f433c6810df091350e3bca"
    sha256 cellar: :any,                 sonoma:        "d7f87a73bb06d65c1c3e5cb5d67fccccfe40ba4abf665909e4693ca41f442527"
    sha256 cellar: :any,                 ventura:       "4275579a0a85d883b83906aa14a4bca6f1759af443bd70a8f8032d10cba925d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "237d70db22ec812af6eb7568604c20868d1766e2e161350892402498c4ff8102"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "601e5d04d6e7d2f1ed8a2c50850952a49fa149f8e6458f841fc2f35725bf8521"
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
