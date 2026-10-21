class Scummvm < Formula
  desc "Graphic adventure game interpreter"
  homepage "https://www.scummvm.org/"
  url "https://downloads.scummvm.org/frs/scummvm/2026.4.0/scummvm-2026.4.0.tar.xz"
  sha256 "cd660b34104da7f85ed0a11b7c6c2320c629bb87ee297935711ebc1e09731f12"
  license "GPL-3.0-or-later"
  head "https://github.com/scummvm/scummvm.git", branch: "master"

  livecheck do
    url "https://www.scummvm.org/downloads/"
    regex(/href=.*?scummvm[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "1097c490df7279bbf4bdf14d013612be4a19b05f23af5a7e49e82789f1748439"
    sha256 arm64_tahoe:       "5bf8ac7de6bebc8fbeabd8c50c7bf82e07b41b5eb3b73e48d6f2faf1c2da7141"
    sha256 arm64_sequoia:     "8452599029f68673c7c99ec55a343cc93e5586b6eb803a206cd9a06711c043ed"
    sha256 arm64_linux:       "1b333d4afa8a1b15983957261befbb0aa7a0dc19536130dfc40dd62117724bcd"
    sha256 x86_64_linux:      "04f6102670243e1436ef9167023253f89ae8962a467ca0b76c68dbe120c5e101"
  end

  depends_on "pkgconf" => :build
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
  depends_on "sdl3"
  depends_on "theora"

  on_macos do
    depends_on "musepack"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "zlib-ng-compat"
  end

  def install
    system "./configure", "--enable-release", "--with-sdl-prefix=#{formula_opt_prefix("sdl3")}", *std_configure_args
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
