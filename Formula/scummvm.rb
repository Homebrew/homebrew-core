class Scummvm < Formula
  desc "Graphic adventure game interpreter"
  homepage "https://www.scummvm.org/"
  url "https://downloads.scummvm.org/frs/scummvm/2.7.0/scummvm-2.7.0.tar.xz"
  sha256 "444b1ffd61774fe867824e57bb3033c9998ffa8a4ed3a13246b01611d5cf9993"
  license "GPL-3.0-or-later"
  head "https://github.com/scummvm/scummvm.git", branch: "master"

  livecheck do
    url "https://www.scummvm.org/downloads/"
    regex(/href=.*?scummvm[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "ff90407f9df7e87b88aa6c24b8a052a99dee66f5d6c36a7f7ae3de763a672648"
    sha256 arm64_monterey: "2b3ba2c5ba922367591b4e79616599d2c2bf6d50c05bfe672513d9fcc90577bf"
    sha256 arm64_big_sur:  "ad21aa5044d5b4d388e95792905568134d30bba5472ed44e4ecc35093a41ee2f"
    sha256 ventura:        "071b7610cce26ea2f608d69d91c333d91c04e08b3f7d9a0c2d69d331322a3d43"
    sha256 monterey:       "0ffb233ace83d6cb367e666bf613d470b517552a0a688c8f11beac58597c1261"
    sha256 big_sur:        "ccab79afdd3bd4d89d7d67e8e466e5b779a4a2e920d68c1c8be97fcdb3189e7e"
    sha256 catalina:       "7f638fae6f450586f19ddef3dc430ab0b5df62ec860de3da33b3d4a37ba111cc"
    sha256 x86_64_linux:   "4c6b6f570d81285892dfedaeae74d7e9081da55d367d6eb6e82f8e188b62888a"
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
    # Test fails on headless CI: Could not initialize SDL: No available video device
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin/"scummvm", "-v"
  end
end
