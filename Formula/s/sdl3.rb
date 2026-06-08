class Sdl3 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https://libsdl.org/"
  url "https://github.com/libsdl-org/SDL/releases/download/release-3.4.10/SDL3-3.4.10.tar.gz"
  sha256 "12b34280415ec8418c864408b93d008a20a6530687ee613d60bfbd20411f2785"
  license "Zlib"
  compatibility_version 1
  head "https://github.com/libsdl-org/SDL.git", branch: "main"

  livecheck do
    url :stable
    regex(/release[._-](\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1de14b4ae2d25ba8066d764affb3cc56a66812951f7fd0955831fa08de97e4e1"
    sha256 cellar: :any, arm64_sequoia: "49d3720d5956085d374d3aa7b3c91da4495aa0dced2cdab4f6d93f53cd6da58b"
    sha256 cellar: :any, arm64_sonoma:  "5ab2cc1a9662e920c7abbf64a9d5237f03c89b98a277d618615887edb4370374"
    sha256 cellar: :any, sonoma:        "0faed51e59db730d1140ac1695c4ca81c95371656f0f671810c87f525f9e2bd4"
    sha256 cellar: :any, arm64_linux:   "8f4665585e9c71309ad0ef9552914992ca58b7f2c024fccc39e7bb428164bb42"
    sha256 cellar: :any, x86_64_linux:  "58c7c57efc23eccf894409dcbc06a00c9c47562250ff9df6008f3699bdf95103"
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
