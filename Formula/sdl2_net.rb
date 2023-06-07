class Sdl2Net < Formula
  desc "Small sample cross-platform networking library"
  homepage "https://github.com/libsdl-org/SDL_net"
  url "https://github.com/libsdl-org/SDL_net/releases/download/release-2.2.0/SDL2_net-2.2.0.tar.gz"
  sha256 "4e4a891988316271974ff4e9585ed1ef729a123d22c08bd473129179dc857feb"
  license "Zlib"

  # NOTE: This should be updated to use the `GithubLatest` strategy if/when the
  # GitHub releases provide downloadable artifacts and the formula uses one as
  # the `stable` URL (like `sdl2_image`, `sdl2_mixer`, etc.).
  livecheck do
    url :head
    regex(/^release[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9e154cc5085e0f5f8d6c21e3656c1ff871497b1d79136105535f6fefc189aafc"
    sha256 cellar: :any,                 arm64_monterey: "293d3240dd1ac9c5aa76317ff632fb216c5a2768632a84400479ba6befcdd6c0"
    sha256 cellar: :any,                 arm64_big_sur:  "218ace24a3d1840ff6b4fd0ae41314a0b69eda326509b2bbf06113c099717d8e"
    sha256 cellar: :any,                 ventura:        "7eafd7b1497736d3609709191a7c693c61e0c2e7761bf1901502dca09a585f41"
    sha256 cellar: :any,                 monterey:       "abc2a0c0a0098fbf6eff04d1a7ac5270de3f96762e0eb068d84bf8f9c484af7d"
    sha256 cellar: :any,                 big_sur:        "a08a23acdd6f6733e64f26bd796bc454d6c8bb8edd91657ffb4175957b5b8b56"
    sha256 cellar: :any,                 catalina:       "d653a5933d4df46a2a4cdf743499821e61e61305cc3eb45d7fa88a8452a0dae1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa5783e335578a64d84051b2fc247b91585a8950f0406fc8b34ad06ea879872f"
  end

  head do
    url "https://github.com/libsdl-org/SDL_net.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "sdl2"

  def install
    inreplace "SDL2_net.pc.in", "@prefix@", HOMEBREW_PREFIX

    system "./autogen.sh" if build.head?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--disable-sdltest"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <SDL2/SDL_net.h>

      int main()
      {
          int success = SDLNet_Init();
          SDLNet_Quit();
          return success;
      }
    EOS

    system ENV.cc, "test.c", "-I#{Formula["sdl2"].opt_include}/SDL2", "-L#{lib}", "-lSDL2_net", "-o", "test"
    system "./test"
  end
end
