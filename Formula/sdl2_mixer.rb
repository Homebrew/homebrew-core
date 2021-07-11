class Sdl2Mixer < Formula
  desc "Sample multi-channel audio mixer library"
  homepage "https://www.libsdl.org/projects/SDL_mixer/"
  url "https://www.libsdl.org/projects/SDL_mixer/release/SDL2_mixer-2.0.4.tar.gz"
  sha256 "b4cf5a382c061cd75081cf246c2aa2f9df8db04bdda8dcdc6b6cca55bede2419"
  license "Zlib"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?SDL2_mixer[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "0c30ec331d3f53fd97f7bac6a6107d49d07e5804e2830c1d2ee536caeaa532e6"
    sha256 cellar: :any, big_sur:       "2fdc878fe345af8ab210786b42bfd998db006b990becd8f7f1bae1f2b2ab1b73"
    sha256 cellar: :any, catalina:      "3533275c4351a77010b161b24f195fd00ede8780e940a477773367eb97cb5008"
    sha256 cellar: :any, mojave:        "6d797207e602091ecee25168556e27f03665f5a9cb5d759152689b62e114f58b"
  end

  head do
    url "https://github.com/libsdl-org/SDL_mixer.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "flac"
  depends_on "libmodplug"
  depends_on "libvorbis"
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
      --disable-music-mp3-mpg123
      --disable-music-mp3-mpg123-shared
      --disable-music-mp3-smpeg
      --disable-music-ogg-shared
      --enable-music-mod-mikmod
      --enable-music-mod-modplug
      --enable-music-ogg
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
