class Sdl2Mixer < Formula
  desc "Sample multi-channel audio mixer library"
  homepage "https://github.com/libsdl-org/SDL_mixer"
  url "https://github.com/libsdl-org/SDL_mixer/releases/download/release-2.6.2/SDL2_mixer-2.6.2.tar.gz"
  sha256 "8cdea810366decba3c33d32b8071bccd1c309b2499a54946d92b48e6922aa371"
  license "Zlib"

  # This formula uses a file from a GitHub release, so we check the latest
  # release version instead of Git tags.
  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/release[._-]v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7fd6ab0b615a7704a6c31069f7efd5979d7619f85793eed2e1e2c25a00d42764"
    sha256 cellar: :any,                 arm64_monterey: "e5b94cc708bc31845f609f89b804641d64c0e0b157a5cb469bdd8a3b1abe9b16"
    sha256 cellar: :any,                 arm64_big_sur:  "a2b8cae3cd3ccc3f6233e3520b935fcd6501c4c9796e1e3c43d41f065eef4fef"
    sha256 cellar: :any,                 ventura:        "fe6119565761b503c1c0c12c4bc3b3524e5d67ee13279a988cb00f8c5924799b"
    sha256 cellar: :any,                 monterey:       "f5491b50e786a11f8df8b2403f1c752d34daa9aa0653fbf52318afa612b45dcc"
    sha256 cellar: :any,                 big_sur:        "7e2b2c284949698bd612764c3eeab7fd2f4a3ae740e2803c369088265860b0a5"
    sha256 cellar: :any,                 catalina:       "c04088e4f0404296e684cb36096279bbc973ebedbad9984c1f8f3c559fc64756"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b38a4c9dc9f8b383818b7a724daa3c970068d4549f4c0f5606b8696a374a4e2b"
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
