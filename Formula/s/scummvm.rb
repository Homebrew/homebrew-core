class Scummvm < Formula
  desc "Graphic adventure game interpreter"
  homepage "https://www.scummvm.org/"
  url "https://downloads.scummvm.org/frs/scummvm/2026.1.0/scummvm-2026.1.0.tar.xz"
  sha256 "e15b8650c2bd9e11b69b49eef9dea1eedccc5b1c191748b15c34167614d77b66"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/scummvm/scummvm.git", branch: "master"

  livecheck do
    url "https://www.scummvm.org/downloads/"
    regex(/href=.*?scummvm[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "70f213a424f5c37fc03b3c396f9492bced7fd3c45dedeebd6aac55491c2968ab"
    sha256 arm64_sequoia: "65d04954c8267ea834b18ccc8475a7ded9b502f24aaa5af557705b0dc9aee12e"
    sha256 arm64_sonoma:  "67106e56a5d5b243918de647830ef431feef80f06159a9214299d2ccdfdb0b11"
    sha256 sonoma:        "56a5f280faee1f9b5b48066c5598479853ee345022ae623542cf08fddabc39e5"
    sha256 arm64_linux:   "5ea5730c8d2a01121b4acaf38a473fca920b498ee04f77ba26351238bc7778b1"
    sha256 x86_64_linux:  "6802bc411def1795e9290a93be941a9cea17db0cb86fc91e43917cad27069e06"
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

  on_macos do
    depends_on "musepack"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "zlib-ng-compat"
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
