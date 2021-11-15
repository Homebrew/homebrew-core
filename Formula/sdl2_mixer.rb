class Sdl2Mixer < Formula
  desc "Sample multi-channel audio mixer library"
  homepage "https://www.libsdl.org/projects/SDL_mixer/"
  url "https://www.libsdl.org/projects/SDL_mixer/release/SDL2_mixer-2.0.4.tar.gz"
  sha256 "b4cf5a382c061cd75081cf246c2aa2f9df8db04bdda8dcdc6b6cca55bede2419"
  license "Zlib"
  revision 2

  livecheck do
    url :homepage
    regex(/href=.*?SDL2_mixer[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "375fbfb9b64fdfc631a7446aa1e21c74f3fc1b5a2e732cbe9db711078fe9c805"
    sha256 cellar: :any,                 arm64_big_sur:  "f3c822ba6f80353d0fee40ea106025d4519e1dbb141d097fef092393e95fb0b7"
    sha256 cellar: :any,                 monterey:       "4784c901a5fe2da26d58b06d1c888cb861874cb16d1211705066dcd7a61027ab"
    sha256 cellar: :any,                 big_sur:        "1529a00916c4066d8adc0987b627e2bc7cf66aca063562cb3af64f8fa5f231f7"
    sha256 cellar: :any,                 catalina:       "9779416544a0d71a8206b45895a3060baca2bf0877441017aaa6b1d6136654a2"
    sha256 cellar: :any,                 mojave:         "9c13dd597aca2e0d5f53f2a7b4a1ea4e5a724c08796ba0eaf71a54f9cc714fbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "412de036ef39cab5f7e1907711c2273a3d671e995ddeda320cad9cfedaa72a28"
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
