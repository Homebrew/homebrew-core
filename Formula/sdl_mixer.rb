class SdlMixer < Formula
  desc "Sample multi-channel audio mixer library"
  homepage "https://www.libsdl.org/projects/SDL_mixer/release-1.2.html"
  url "https://www.libsdl.org/projects/SDL_mixer/release/SDL_mixer-1.2.12.tar.gz"
  sha256 "1644308279a975799049e4826af2cfc787cad2abb11aa14562e402521f86992a"
  license "Zlib"
  revision 4

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9047d69bc3613a2ea58ee77bf374ddbfbbd769e0cc5fc90b505dec9184045194"
    sha256 cellar: :any,                 arm64_big_sur:  "20d1beb530df525f4aa8d5e4716eb9acf5a54330076c6ba3c1784b88a9e9e3f8"
    sha256 cellar: :any,                 monterey:       "893886f33dfe8e0b6b50fddc62e4b424388a4d29e5f635766f5ff06045fd0e2f"
    sha256 cellar: :any,                 big_sur:        "0bd16f40744f277701a46fda52b3df4aecff40371e3ae84b09556ec3e2a3bc63"
    sha256 cellar: :any,                 catalina:       "9b63c289fadc5382e5c77d77ba5e04d05f30532508a1512a6e5a7afb6e2c472a"
    sha256 cellar: :any,                 mojave:         "dd69b75165f502ff2540c6e6fa72645049b8bc25ed1794b36d3757a8bc74eb97"
    sha256 cellar: :any,                 high_sierra:    "a6e0ff3e96a41f88892cf1fcee7d8c21fd816094f48d376640f77184a8c78e06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d55c99488eaba1c54abb3f33d7ccf71978d958f05ec9c631d384d5909d4ddeb2"
  end

  head do
    url "https://github.com/libsdl-org/SDL_mixer.git", branch: "SDL-1.2"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # SDL 1.2 is deprecated, unsupported, and not recommended for new projects.
  deprecate! date: "2013-08-17", because: :deprecated_upstream

  depends_on "pkg-config" => :build
  depends_on "flac"
  depends_on "libmikmod"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "sdl"

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
                   "-I#{Formula["sdl"].opt_include}/SDL",
                   "-L#{lib}", "-lSDL_mixer",
                   "-L#{Formula["sdl"].lib}", "-lSDLmain", "-lSDL",
                   "-o", "playwave"
    Utils.safe_popen_read({ "SDL_VIDEODRIVER" => "dummy", "SDL_AUDIODRIVER" => "disk" },
                          "./playwave", test_fixtures("test.wav"))
    assert_predicate testpath/"sdlaudio.raw", :exist?
  end
end
