class Sdl2Net < Formula
  desc "Small sample cross-platform networking library"
  homepage "https://github.com/libsdl-org/SDL_net"
  url "https://github.com/libsdl-org/SDL_net/releases/download/release-2.4.0/SDL2_net-2.4.0.tar.gz"
  sha256 "9cbca2527feb3f1a622d48ba65cc7dee9b1e3f2c55ceafb7d7720bb058aafb30"
  license "Zlib"

  livecheck do
    url :stable
    regex(/^(?:release[._-])?v?(2(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "842b8be579abc9a3de68666c5654c86781e8a2dbf7ed4ea7eb116e9019249113"
    sha256 cellar: :any,                 arm64_sequoia: "b6d21421e3538a00c2dee025bba678231f03c99e68a354ba3ed44ffadc691aac"
    sha256 cellar: :any,                 arm64_sonoma:  "7c01db425e662ec301c077d6ec6cafc0426aeeff7b04a3f5abe07cd46a0f57b7"
    sha256 cellar: :any,                 sonoma:        "5e5dafd02e711e46e3f0547b003a2d6b467efabfcdcf4aaf7f7b217ba913f0cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7551589bd6c60d0685c19fd6eb3be3a46cb75a01b3a7d10d46a16ff5d6976181"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffd51b211a29509081c1bf2969f724607803db3237f3a861af0a071611677b9d"
  end

  head do
    url "https://github.com/libsdl-org/SDL_net.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "sdl2"

  def install
    inreplace "SDL2_net.pc.in", "@prefix@", HOMEBREW_PREFIX

    system "./autogen.sh" if build.head?

    system "./configure", "--disable-sdltest", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <SDL2/SDL_net.h>

      int main()
      {
          int success = SDLNet_Init();
          SDLNet_Quit();
          return success;
      }
    C

    system ENV.cc, "test.c", "-I#{Formula["sdl2"].opt_include}/SDL2", "-L#{lib}", "-lSDL2_net", "-o", "test"
    system "./test"
  end
end
