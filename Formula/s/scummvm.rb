class Scummvm < Formula
  desc "Graphic adventure game interpreter"
  homepage "https://www.scummvm.org/"
  url "https://downloads.scummvm.org/frs/scummvm/2.9.0/scummvm-2.9.0.tar.xz"
  sha256 "d5b33532bd70d247f09127719c670b4b935810f53ebb6b7b6eafacaa5da99452"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/scummvm/scummvm.git", branch: "master"

  livecheck do
    url "https://www.scummvm.org/downloads/"
    regex(/href=.*?scummvm[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "2772b8bf2e6a646edb3e99dbeb28c963d843585763a030b4b22e1a5d620ad16e"
    sha256 arm64_sonoma:  "1a28258561716796a44065436d30cd651d64329375c23a0237a40ac1433e74c5"
    sha256 arm64_ventura: "fa5357d50358654f04d462eaa2458f6ef707c30f1c1ee07a8eced50dc31e058c"
    sha256 sonoma:        "fe1e116080ede23f15a5ce52a2403bbb252491c5b1745315e8ff8b09db4d6766"
    sha256 ventura:       "5278a0db160646fd32761711dcf7286dfd9998eaf5c5c451a8600431b7e7c0ac"
    sha256 arm64_linux:   "288dfd03828695c6de1cd90c3e048017ad961f0e8152eae55c253f91192e2537"
    sha256 x86_64_linux:  "4b6ca803fb0574e1fbef9adedacca832cd0466465e821d2639676784c6f5899f"
  end

  depends_on "a52dec"
  depends_on "faad2"
  depends_on "flac"
  depends_on "fluid-synth"
  depends_on "freetype"
  depends_on "fribidi"
  depends_on "giflib"
  depends_on "jpeg-turbo"
  depends_on "libmpeg2"
  depends_on "libogg"
  depends_on "libopenmpt"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "libvpx"
  depends_on "mad"
  depends_on "sdl2"
  depends_on "theora"

  uses_from_macos "zlib"

  on_macos do
    depends_on "musepack"
  end

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    system "./configure", "--enable-release", "--with-sdl-prefix=#{Formula["sdl2"].opt_prefix}", *std_configure_args
    system "make", "install"

    rm_r(share/"pixmaps")
    rm_r(share/"icons")
  end

  test do
    # Use dummy driver to avoid issues with headless CI
    ENV["SDL_VIDEODRIVER"] = "dummy"
    ENV["SDL_AUDIODRIVER"] = "dummy"
    system bin/"scummvm", "-v"
  end
end
