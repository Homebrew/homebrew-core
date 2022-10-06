class SdlSound < Formula
  desc "Library to decode several popular sound file formats"
  homepage "https://icculus.org/SDL_sound/"
  url "https://icculus.org/SDL_sound/downloads/SDL_sound-1.0.3.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/s/sdl-sound1.2/sdl-sound1.2_1.0.3.orig.tar.gz"
  sha256 "3999fd0bbb485289a52be14b2f68b571cb84e380cc43387eadf778f64c79e6df"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d841ce9a75188dabed5f60bcac15b5fe587a27e1dd852cb1373a527166f6ebed"
    sha256 cellar: :any,                 arm64_big_sur:  "34642d25aacd4036655c9a70ed1fb053e1bd97c6d6854cf4a9891efc09c17378"
    sha256 cellar: :any,                 monterey:       "deaac135b0a7474a0cb2084c41296f3e16f43201288f555e756f7f7591e37d60"
    sha256 cellar: :any,                 big_sur:        "f0f6b7aee1a5f2307e3e220b0e1fada6f10a524cf077c413d55079eebc36c1c6"
    sha256 cellar: :any,                 catalina:       "0701c8b7c293a52efb1d2d62cb3619b1348260c2d6ea975ca519b05a9d6c5627"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b87660a6a669220b3e7c8b8f6f0283a196180aa274e134aa342a04cd63b443f"
  end

  head do
    url "https://github.com/icculus/SDL_sound.git", branch: "stable-1.0"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  keg_only "it conflicts with `sdl2_sound`"

  # SDL 1.2 is deprecated, unsupported, and not recommended for new projects.
  # Commented out while this formula still has dependents.
  # deprecate! date: "2013-08-17", because: :deprecated_upstream

  depends_on "pkg-config" => :build
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "sdl12-compat"

  def install
    system "./autogen.sh" if build.head?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-sdltest"
    system "make"
    system "make", "install"
  end
end
