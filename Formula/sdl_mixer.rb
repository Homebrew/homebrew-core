class SdlMixer < Formula
  desc "Sample multi-channel audio mixer library"
  homepage "https://www.libsdl.org/projects/SDL_mixer/"
  url "https://www.libsdl.org/projects/SDL_mixer/release/SDL_mixer-1.2.12.tar.gz"
  sha256 "1644308279a975799049e4826af2cfc787cad2abb11aa14562e402521f86992a"
  license "Zlib"
  revision 4

  livecheck do
    url "https://www.libsdl.org/projects/SDL_mixer/release/"
    regex(/href=.*?SDL_mixer[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "0bd16f40744f277701a46fda52b3df4aecff40371e3ae84b09556ec3e2a3bc63" => :big_sur
    sha256 "20d1beb530df525f4aa8d5e4716eb9acf5a54330076c6ba3c1784b88a9e9e3f8" => :arm64_big_sur
    sha256 "9b63c289fadc5382e5c77d77ba5e04d05f30532508a1512a6e5a7afb6e2c472a" => :catalina
    sha256 "dd69b75165f502ff2540c6e6fa72645049b8bc25ed1794b36d3757a8bc74eb97" => :mojave
    sha256 "a6e0ff3e96a41f88892cf1fcee7d8c21fd816094f48d376640f77184a8c78e06" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "flac"
  depends_on "libmikmod"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "sdl"

  # Source file for sdl_mixer example
  resource "playwave" do
    url "https://hg.libsdl.org/SDL_mixer/raw-file/a4e9c53d9c30/playwave.c"
    sha256 "92f686d313f603f3b58431ec1a3a6bf29a36e5f792fb78417ac3d5d5a72b76c9"
  end

  def install
    inreplace "SDL_mixer.pc.in", "@prefix@", HOMEBREW_PREFIX

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
    system ENV.cc, "-o", "playwave", "playwave.c", "-I#{include}/SDL",
                   "-I#{Formula["sdl"].opt_include}/SDL",
                   "-L#{lib}", "-lSDL_mixer",
                   "-L#{Formula["sdl"].lib}", "-lSDLmain", "-lSDL",
                   "-Wl,-framework,Cocoa"
    Utils.safe_popen_read({ "SDL_VIDEODRIVER" => "dummy", "SDL_AUDIODRIVER" => "disk" },
                          "./playwave", test_fixtures("test.wav"))
    assert_predicate testpath/"sdlaudio.raw", :exist?
  end
end
