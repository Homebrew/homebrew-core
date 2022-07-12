class Sdl2Mixer < Formula
  desc "Sample multi-channel audio mixer library"
  homepage "https://github.com/libsdl-org/SDL_mixer"
  url "https://github.com/libsdl-org/SDL_mixer/releases/download/release-2.6.0/SDL2_mixer-2.6.0.tar.gz"
  sha256 "f94a4d3e878cb191c386a714be561838240012250fe17d496f4ff4341d59a391"
  license "Zlib"

  # This formula uses a file from a GitHub release, so we check the latest
  # release version instead of Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "efb9299c264820950d859c9500bc6b29f8bca49f811a2463f8fc410abc75df78"
    sha256 cellar: :any,                 arm64_big_sur:  "93f0cc1c49c8dc01ca2a8765f2b798ae733c1a6f07a16df45eba1015d1f6df02"
    sha256 cellar: :any,                 monterey:       "9a03671374b854ec1b8bc010883def60e47d92c88208a6ab01c23b8707aed65c"
    sha256 cellar: :any,                 big_sur:        "b0db96bcf83bd87c40fe9695c71ab569dba29d4cc82519cf180f7c74f8cb6721"
    sha256 cellar: :any,                 catalina:       "c4ecc918adf85671134ab3bd631a1023587ab21c03da5688850d0c29e9e1600c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "433d1c19c9da31181c772349fe65589f3485700e5e028ea59eb3ae1fc6508f70"
  end

  head do
    url "https://github.com/libsdl-org/SDL_mixer.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "flac"
  depends_on "libmodplug"
  depends_on "libvorbis"
  depends_on "mpg123"
  depends_on "sdl2"

  def install
    inreplace "SDL2_mixer.pc.in", "@prefix@", HOMEBREW_PREFIX

    if build.head?
      mkdir "build"
      system "./autogen.sh"
    end

    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --enable-music-flac
      --disable-music-flac-shared
      --disable-music-midi-fluidsynth
      --disable-music-midi-fluidsynth-shared
      --disable-music-mod-mikmod-shared
      --disable-music-mod-modplug-shared
      --disable-music-mp3-mpg123-shared
      --disable-music-ogg-shared
      --enable-music-mod-mikmod
      --enable-music-mod-modplug
      --enable-music-ogg
      --enable-music-mp3-mpg123
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <SDL2/SDL_mixer.h>

      int main()
      {
          int success = Mix_Init(0);
          Mix_Quit();
          return success;
      }
    EOS
    system ENV.cc, "-I#{Formula["sdl2"].opt_include}/SDL2",
           "test.c", "-L#{lib}", "-lSDL2_mixer", "-o", "test"
    system "./test"
  end
end
