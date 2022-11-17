class SdlMixer < Formula
  desc "Sample multi-channel audio mixer library"
  homepage "https://www.libsdl.org/projects/SDL_mixer/release-1.2.html"
  url "https://www.libsdl.org/projects/SDL_mixer/release/SDL_mixer-1.2.12.tar.gz"
  sha256 "1644308279a975799049e4826af2cfc787cad2abb11aa14562e402521f86992a"
  license "Zlib"
  revision 6

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9011aeb2677555c32d4fbed09977e07faf7b9eea1e12f6a5b9802c504ad8dfe0"
    sha256 cellar: :any,                 arm64_monterey: "3a887eb57fef0c55e2b1696f465ab80f449785d3b7708c183a5484d079bd22da"
    sha256 cellar: :any,                 arm64_big_sur:  "e8b3fe965cb691647c21d62e06fd2d04f287a03b7a6b91a087c8e869354aef54"
    sha256 cellar: :any,                 ventura:        "9e71b3de0e9c7bef14278104a089eb65ac11d1ff0984629761d498416d0f948a"
    sha256 cellar: :any,                 monterey:       "7c3b42e4f38050ac7534257208ee8fe7cd3660670b8665d5fd88bb09625000f4"
    sha256 cellar: :any,                 big_sur:        "3bd79dfc2a50e07eeb6e652f3c3300885af35eb2003f77de50c13aec41c2fbe6"
    sha256 cellar: :any,                 catalina:       "8359f5a56d710ae172c19c6e8567346b5fd6629f787e0168ac88ef571baed992"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8cced855d34a9dd5e40b702e34664507f2dc94ced4d7d09736d491d58a7366e4"
  end

  head do
    url "https://github.com/libsdl-org/SDL_mixer.git", branch: "SDL-1.2"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # SDL 1.2 is deprecated, unsupported, and not recommended for new projects.
  # Commented out while this formula still has dependents.
  # deprecate! date: "2013-08-17", because: :deprecated_upstream

  depends_on "pkg-config" => :build
  depends_on "flac"
  depends_on "libmikmod"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "sdl12-compat"

  # Source file for sdl_mixer example
  resource "playwave" do
    url "https://github.com/libsdl-org/SDL_mixer/raw/1a14d94ed4271e45435ecb5512d61792e1a42932/playwave.c"
    sha256 "92f686d313f603f3b58431ec1a3a6bf29a36e5f792fb78417ac3d5d5a72b76c9"
  end

  def install
    inreplace "SDL_mixer.pc.in", "@prefix@", HOMEBREW_PREFIX

    system "./autogen.sh" if build.head?

    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --enable-music-ogg
      --enable-music-flac
      --disable-music-ogg-shared
      --disable-music-mod-shared
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    testpath.install resource("playwave")
    cocoa = []
    cocoa << "-Wl,-framework,Cocoa" if OS.mac?
    system ENV.cc, "playwave.c", *cocoa, "-I#{include}/SDL",
                   "-I#{Formula["sdl12-compat"].opt_include}/SDL",
                   "-L#{lib}", "-lSDL_mixer",
                   "-L#{Formula["sdl12-compat"].lib}", "-lSDLmain", "-lSDL",
                   "-o", "playwave"
    Utils.safe_popen_read({ "SDL_VIDEODRIVER" => "dummy", "SDL_AUDIODRIVER" => "disk" },
                          "./playwave", test_fixtures("test.wav"))
    assert_predicate testpath/"sdlaudio.raw", :exist?
  end
end
