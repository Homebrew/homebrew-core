class SdlSound < Formula
  desc "Library to decode several popular sound file formats"
  homepage "https://icculus.org/SDL_sound/"
  url "https://icculus.org/SDL_sound/downloads/SDL_sound-1.0.3.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/s/sdl-sound1.2/sdl-sound1.2_1.0.3.orig.tar.gz"
  sha256 "3999fd0bbb485289a52be14b2f68b571cb84e380cc43387eadf778f64c79e6df"
  revision 2

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "31ec491a6db5c71f40d122b891a513d891c47bf35682455d7d47958ace385afa"
    sha256 cellar: :any,                 arm64_ventura:  "9bea3a01efd7405fe3ad4899021c3c434576d8759be0702916e310faf7109bda"
    sha256 cellar: :any,                 arm64_monterey: "26511aae3187e1aeb339e8d35c50ac417df5e7018ce86077216d3646419bb2b9"
    sha256 cellar: :any,                 arm64_big_sur:  "7db0a9528c281c47c1fd4f79ce956269c8b3f37507c3669393024e79fcd965be"
    sha256 cellar: :any,                 sonoma:         "92e2d4f7ec97bd1d230f2a952e2ee69af06d5c3d774a2b3eb500c46d3ebcd194"
    sha256 cellar: :any,                 ventura:        "cb2fabfb579addf24b786c91df552d78d060051f4c398fd8cc72749b755062a5"
    sha256 cellar: :any,                 monterey:       "9b5e444e0c09b52dc480459c5d0485815cbdcfb1ee00c3d8f02c0be3dd313cde"
    sha256 cellar: :any,                 big_sur:        "8ea00e26e1d3714af082d90b09f33046b92dc2384b5095aeb6362efb7b32f4cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76f7b947c3a41598d7aff64f21d438c85bbc2cb8d1bf33774e33f1bd364980f9"
  end

  head do
    url "https://github.com/icculus/SDL_sound.git", branch: "stable-1.0"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  keg_only "it conflicts with `sdl2_sound`"

  # SDL 1.2 is deprecated, unsupported, and not recommended for new projects.
  disable! date: "2024-02-16", because: :deprecated_upstream

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
