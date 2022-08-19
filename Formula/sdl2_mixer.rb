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
    sha256 cellar: :any,                 arm64_monterey: "0e875d4331ba85cb625555f1b4438a1317f02e95a9cac9f77eb5a8d8c7a19987"
    sha256 cellar: :any,                 arm64_big_sur:  "f6834560a29e6c8a3072cecf24145058efce8fae30bfe321225319b0c7819823"
    sha256 cellar: :any,                 monterey:       "adf9e45386be2f3ce2ae531e6d124c3d5f257edd8662f55631e338622a0598e1"
    sha256 cellar: :any,                 big_sur:        "d8aad7143f7ff8f4c1d04fa988fafa0e5f461be113b1640b372a3faddcecb149"
    sha256 cellar: :any,                 catalina:       "c429a9719bec87c8bab90b795b1bcf6e5cc4ddc55abd5a84844c61502bd3f373"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a909b72a55446ed858eb836a7ac29227942dd7799c3f74e3f067279bdc91c8a"
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
