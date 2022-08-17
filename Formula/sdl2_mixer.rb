class Sdl2Mixer < Formula
  desc "Sample multi-channel audio mixer library"
  homepage "https://github.com/libsdl-org/SDL_mixer"
  url "https://github.com/libsdl-org/SDL_mixer/releases/download/release-2.6.1/SDL2_mixer-2.6.1.tar.gz"
  sha256 "bc5c7b85f297e5f3cb34c99c366a4746922fc41365b15fd78a164dda71a861a3"
  license "Zlib"

  # This formula uses a file from a GitHub release, so we check the latest
  # release version instead of Git tags.
  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/release[._-]v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d6b6b29cc6681cc4007160f3cc6550bf93eb648802d12c0e3c051558bf4ce3b6"
    sha256 cellar: :any,                 arm64_big_sur:  "6292ec831d3b011033d3d1c39b62416566bfcfe0765ebc6765434573b2717908"
    sha256 cellar: :any,                 monterey:       "ae3440fea6ed195556c35d219f994fc9d1aa0a890f371ab92feecdf88089c70c"
    sha256 cellar: :any,                 big_sur:        "596454b3f76224043a3fa5868759af52863db0e53786ea2c24f8ef6e9f569d9a"
    sha256 cellar: :any,                 catalina:       "6f53dbfeecb85112c38ad1cb03b46096d00ee25feda58173ef63c8797cddf64d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3653463a39485ebd265e0ffa747d2bfe652ba7acec1bfe32782da62ac816494b"
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
