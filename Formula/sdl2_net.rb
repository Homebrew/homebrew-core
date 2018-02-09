class Sdl2Net < Formula
  desc "Small sample cross-platform networking library"
  homepage "https://www.libsdl.org/projects/SDL_net/"
  url "https://www.libsdl.org/projects/SDL_net/release/SDL2_net-2.0.1.tar.gz"
  sha256 "15ce8a7e5a23dafe8177c8df6e6c79b6749a03fff1e8196742d3571657609d21"

  bottle do
    cellar :any
    sha256 "f193c7c2ae1b7f2c82cbbc9b83a16fc72d845c6396ecd33644eea19695a850ee" => :high_sierra
    sha256 "dc2b96762f77dd4d42fea1da4d4c2373692dd0a531f686f00de0dd4a6eed8df9" => :sierra
    sha256 "46d189ebe1f240381a9e8d99a2cb249e577cec98e6399e741e47275735a3471c" => :el_capitan
    sha256 "2e2bcc1e1aac84b37ebb44398e463d9004764aa369489926cd07bb97cb9f60c4" => :yosemite
    sha256 "ebabcb8f4df6fdee7855a6e19080aea42d9909205b287312015179bb9b3f472a" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "sdl2"

  def install
    inreplace "SDL2_net.pc.in", "@prefix@", HOMEBREW_PREFIX

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

    system ENV.cc, "-L#{lib}", "-lsdl2_net", "test.c", "-o", "test"
    system "./test"
  end
end
