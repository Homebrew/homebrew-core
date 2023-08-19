class Scummvm < Formula
  desc "Graphic adventure game interpreter"
  homepage "https://www.scummvm.org/"
  url "https://downloads.scummvm.org/frs/scummvm/2.7.1/scummvm-2.7.1.tar.xz"
  sha256 "d6bbf62e33154759a609d59f3034d71652ecdb64ed5c800156718ab1f1d5d063"
  license "GPL-3.0-or-later"
  head "https://github.com/scummvm/scummvm.git", branch: "master"

  livecheck do
    url "https://www.scummvm.org/downloads/"
    regex(/href=.*?scummvm[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "6e72919f378fc00fa734fdcbc032ec9dd6a526d832afcbad2dc2508309e8a0c5"
    sha256 arm64_monterey: "e0dbf93235c69abcdc74739a86c993a1cda5af2178b9b10e570fc9c39c277738"
    sha256 arm64_big_sur:  "cfefac96fcf8ea55b34727b1e1246e847c423459eaa06449f1f17068079af7c6"
    sha256 ventura:        "bc4d8eef158398d33c5b69fd4bf74b781414aaf383c1ac318a522716c89c978a"
    sha256 monterey:       "718314462b5ab77647835511ab5c5c951d96aff71df6dabfd5969c5c826b8c5d"
    sha256 big_sur:        "217f483d0b009c406c3cf07c917d086214cc6ce818d1215caa4626ede53b074e"
    sha256 x86_64_linux:   "71f71a1bd138c5b4e97a8db656ec662af5259fd93f49b14617a31d66c18b6135"
  end

  depends_on "a52dec"
  depends_on "faad2"
  depends_on "flac"
  depends_on "fluid-synth"
  depends_on "freetype"
  depends_on "jpeg-turbo"
  depends_on "libmpeg2"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "sdl2"
  depends_on "theora"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--enable-release",
                          "--with-sdl-prefix=#{Formula["sdl2"].opt_prefix}"
    system "make"
    system "make", "install"
    (share/"pixmaps").rmtree
    (share/"icons").rmtree
  end

  test do
    # Use dummy driver to avoid issues with headless CI
    ENV["SDL_VIDEODRIVER"] = "dummy"
    ENV["SDL_AUDIODRIVER"] = "dummy"
    system bin/"scummvm", "-v"
  end
end
