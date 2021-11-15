class Sdl2Net < Formula
  desc "Small sample cross-platform networking library"
  homepage "https://www.libsdl.org/projects/SDL_net/"
  url "https://www.libsdl.org/projects/SDL_net/release/SDL2_net-2.0.1.tar.gz"
  sha256 "15ce8a7e5a23dafe8177c8df6e6c79b6749a03fff1e8196742d3571657609d21"
  license "Zlib"

  livecheck do
    url :homepage
    regex(/href=.*?SDL2_net[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7703b5b6acb691cf7c0ab3f94ae2c2a57929fc33d379a00dc5f701ff092dad77"
    sha256 cellar: :any,                 arm64_big_sur:  "b1c2224931852ae88aa4a3ee1e70d5576ee74521c3a893ecd16876c7b0fa35db"
    sha256 cellar: :any,                 monterey:       "b8a40bbb05a6fa5a744408a48ea332261c13ed7a6c23e8c93f91c69b42a69329"
    sha256 cellar: :any,                 big_sur:        "d270144e643a239af9c4a7ad0f0ef5277e54bfd845caaa0cf9a7be232cd8d41a"
    sha256 cellar: :any,                 catalina:       "920e892ba80cba3a99d4a15473351be5dc23f0d9445c28480c5dae904e8a8271"
    sha256 cellar: :any,                 mojave:         "0631754a7016b3e6e175644cc7976cc22843f7b872e8f50662d0cb50a4264901"
    sha256 cellar: :any,                 high_sierra:    "f193c7c2ae1b7f2c82cbbc9b83a16fc72d845c6396ecd33644eea19695a850ee"
    sha256 cellar: :any,                 sierra:         "dc2b96762f77dd4d42fea1da4d4c2373692dd0a531f686f00de0dd4a6eed8df9"
    sha256 cellar: :any,                 el_capitan:     "46d189ebe1f240381a9e8d99a2cb249e577cec98e6399e741e47275735a3471c"
    sha256 cellar: :any,                 yosemite:       "2e2bcc1e1aac84b37ebb44398e463d9004764aa369489926cd07bb97cb9f60c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "861e38494187fb28cdbd10b7c796d45db51c08c38d62ca539b55b48befa0ae9a"
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
