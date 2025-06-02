class Scummvm < Formula
  desc "Graphic adventure game interpreter"
  homepage "https://www.scummvm.org/"
  url "https://downloads.scummvm.org/frs/scummvm/2.9.1/scummvm-2.9.1.tar.xz"
  sha256 "6a82f36afa9de758ab1dd377101a26a53f12417cbfd350bb8e5d7fd5b8c257e3"
  license "GPL-3.0-or-later"
  head "https://github.com/scummvm/scummvm.git", branch: "master"

  livecheck do
    url "https://www.scummvm.org/downloads/"
    regex(/href=.*?scummvm[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "ab8474a65c3527d55e6ce9fe648b3b882c4a21e07e212a56e31458d6c52f5e3b"
    sha256 arm64_sonoma:  "ccc56d8a5e804484beda52790e6caf022326c08fc7bbc8213ba123f7adacae40"
    sha256 arm64_ventura: "aa89c7c11339ef53dba8adcba16397234b251f56572312bc8134b8a8128d83b0"
    sha256 sonoma:        "53a02155697992a98142a5a47fcb14a77b65f08266b2fbe76636237d558fa8c0"
    sha256 ventura:       "e5b2a610f0684c5f2fb72f33f848674a0c5182b225061f030625467d485a9926"
    sha256 arm64_linux:   "fea57115c7c0b57b4d2265c1ff5648ad7f5d5db56530f48aa19413e2153579d7"
    sha256 x86_64_linux:  "2d2a98f4ee32de3e3537ee2515372bcb8de7e1d9f9f24af3d8443922da92fd1b"
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
