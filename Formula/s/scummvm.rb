class Scummvm < Formula
  desc "Graphic adventure game interpreter"
  homepage "https://www.scummvm.org/"
  url "https://downloads.scummvm.org/frs/scummvm/2.9.0/scummvm-2.9.0.tar.xz"
  sha256 "d5b33532bd70d247f09127719c670b4b935810f53ebb6b7b6eafacaa5da99452"
  license "GPL-3.0-or-later"
  head "https://github.com/scummvm/scummvm.git", branch: "master"

  livecheck do
    url "https://www.scummvm.org/downloads/"
    regex(/href=.*?scummvm[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "fd386b790796cd93212f0a48afa615a96f38dab6f8100b9a106d7b162daa575e"
    sha256 arm64_sonoma:  "b5d4e2c4810e5891a7e4cf6a81a393cefb136ad120542995d5f05ea28c9f7e46"
    sha256 arm64_ventura: "11a8e89fafed34c094e689e1b93457afd24a56416fe49f3e6eb085dfb40bebe0"
    sha256 sonoma:        "6043f6417fbbfd4b12b4412804ad9e11ccc1874eb9a846a182aa182f9cf3d30d"
    sha256 ventura:       "7972f1c506a5241495960fcbc77d366567a7d0f66ecd0b01ebbc351a2e9d5851"
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
  depends_on "musepack"
  depends_on "sdl2"
  depends_on "theora"

  uses_from_macos "zlib"

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
