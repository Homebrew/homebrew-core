class Scummvm < Formula
  desc "Graphic adventure game interpreter"
  homepage "https://www.scummvm.org/"
  url "https://downloads.scummvm.org/frs/scummvm/2026.2.0/scummvm-2026.2.0.tar.xz"
  sha256 "4e10ed977daa36780c97a9b3bd7c124842f5ed9b0bfea4e8e35eda4658fa60f3"
  license "GPL-3.0-or-later"
  head "https://github.com/scummvm/scummvm.git", branch: "master"

  livecheck do
    url "https://www.scummvm.org/downloads/"
    regex(/href=.*?scummvm[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "eafd8445aa49bbf8247d5380b5d21fafd02ed092c600091c6f029329ad1f0fb6"
    sha256 arm64_sequoia: "01e515ec6a9adba2246458cafe739339b730b30ac24c6266dc1fc587cc7cff25"
    sha256 arm64_sonoma:  "ff098c5d5f81416f9710d5201b1a26d1de3efcafc23ddc1f1b0937c94105abcd"
    sha256 sonoma:        "9e261a9ae5575bf012567d412ec387b847c4171758436586f4591f9d8c8bce20"
    sha256 arm64_linux:   "afebdf0abbb5231b0381a3246a72d083a4bdec2a00b5fbf49a02b80f590353e4"
    sha256 x86_64_linux:  "db0f23cfe965073d71e226dcdf9e6dbbb218bf64a8ce885ca1cdfdae85ddc08e"
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
