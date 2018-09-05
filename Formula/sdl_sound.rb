class SdlSound < Formula
  desc "Library to decode several popular sound file formats"
  homepage "https://icculus.org/SDL_sound/"
  url "https://icculus.org/SDL_sound/downloads/SDL_sound-1.0.3.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/s/sdl-sound1.2/sdl-sound1.2_1.0.3.orig.tar.gz"
  sha256 "3999fd0bbb485289a52be14b2f68b571cb84e380cc43387eadf778f64c79e6df"
  revision 1

  bottle do
    cellar :any
    sha256 "3661daa8d14b8b8ab613a5fb449ad6b3f758739eb3b69700b23c0ccdc49068b6" => :mojave
    sha256 "c571e007bcbb022e6fd0042e506ce6cd47a26d814de06f348b13231fc95a1581" => :high_sierra
    sha256 "0e692b6c08600d6d7014fc582b5a351e8a4eea42ce95d231ef39a0c07c41c71b" => :sierra
    sha256 "fd93d8be366bfe3f16839f50d11ab1149cc725c6bf6248befe90feae25c0e052" => :el_capitan
    sha256 "8f06d7c6c18c8a5192aebf5672c20f9f3b27bbd3109459ef96110d935c00f87b" => :yosemite
  end

  head do
    url "https://hg.icculus.org/icculus/SDL_sound", :using => :hg

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "sdl"

  def install
    if build.head?
      inreplace "bootstrap", "/usr/bin/glibtoolize", "#{Formula["libtool"].opt_bin}/glibtoolize"
      system "./bootstrap"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-sdltest"
    system "make"
    system "make", "check"
    system "make", "install"
  end
end
