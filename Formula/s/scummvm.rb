class Scummvm < Formula
  desc "Graphic adventure game interpreter"
  homepage "https://www.scummvm.org/"
  url "https://downloads.scummvm.org/frs/scummvm/2.9.0/scummvm-2.9.0.tar.xz"
  sha256 "d5b33532bd70d247f09127719c670b4b935810f53ebb6b7b6eafacaa5da99452"
  license "GPL-3.0-or-later"
  revision 2
  head "https://github.com/scummvm/scummvm.git", branch: "master"

  livecheck do
    url "https://www.scummvm.org/downloads/"
    regex(/href=.*?scummvm[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "54f576a9480d41e61bbd263c37fd85bc17b5f825ae791b348aa56d1bccbf969a"
    sha256 arm64_sonoma:  "05b1d1b9f7ba3af7b6449d5048087bbf8bc06ef1ffa57c1c04c3bced3470fe2c"
    sha256 arm64_ventura: "bf8c4d0ca4e73be6ce65a23c0d7681f4215ad4c4893fd14eb34a36546928cf0f"
    sha256 sonoma:        "84b4384af63a7d9e3b8cd0e3744d761ddad5b992a5aa47328c9e89474a41f6c6"
    sha256 ventura:       "3ed0ded5307ab17e2c3c80ba2033212b714dbe90133d8d17d7229d650507841b"
    sha256 arm64_linux:   "5cdbdf040836910a46c4a4ef8291ac2b7acc32e8c0c9a8c3cc5d57cf40bd0d8a"
    sha256 x86_64_linux:  "da251351daf387dc719882bd00afe956ebf475590f6cbc198df1a4a03d0c079d"
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
