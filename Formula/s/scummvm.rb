class Scummvm < Formula
  desc "Graphic adventure game interpreter"
  homepage "https://www.scummvm.org/"
  url "https://downloads.scummvm.org/frs/scummvm/2026.3.0/scummvm-2026.3.0.tar.xz"
  sha256 "b863a81e1598df8bc4aa0c33e3d9b1c8bbede1879d94d91568a4f200057677e7"
  license "GPL-3.0-or-later"
  head "https://github.com/scummvm/scummvm.git", branch: "master"

  livecheck do
    url "https://www.scummvm.org/downloads/"
    regex(/href=.*?scummvm[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "b455f8d4383d4962b3cef55e01b6464b2feef15987a3d5c8ea09c6311d2c6687"
    sha256 arm64_sequoia: "21d1b303998c59f302391eab6083b4e01e53c7a5cfab7e651eb72ce83ddb6094"
    sha256 arm64_sonoma:  "49e4cf8f74f697c2de6d9db8901067b4d7e60d6a683969298a67d22de4d60656"
    sha256 sonoma:        "36433b21489495597600cb0c4e9cd309a89c8f833081d08da4416983e8caac3f"
    sha256 arm64_linux:   "718dde37a4bbe56b9cf7ab3164c920417dd5162fd2596f2f1fa50abbb9492e70"
    sha256 x86_64_linux:  "7a160b1d12ca0fbddffd74a070d955fc8a4e1444853f3401cb880de797ac33fc"
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
