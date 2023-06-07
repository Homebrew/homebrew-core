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
    sha256 arm64_ventura:  "550a1b394b3ce96aa23f5c06730a9ffb94af558ff5064878af1c4ebeedc5ec94"
    sha256 arm64_monterey: "6a3e4f2670f4bfe040618dca252120b1946148056c22d9548d5eebdb0fcaa072"
    sha256 arm64_big_sur:  "f568c1d596748d76b628ed548bbbe8b17edf8fb780eca5deb5099a74841b9db5"
    sha256 ventura:        "b6b91116e0bc3a6aba9ffcc8ce427d0492bc38277d83c00b3d72c4df4d84f5e8"
    sha256 monterey:       "9f491464ff065d629b7c355a1c50c21b751d7631c5bcc164fbb8f2be13531078"
    sha256 big_sur:        "517a01101d6a3c71ce9409433e8ca5f5cf05cc91cc07a2c472d48d4ff6cbb3e8"
    sha256 x86_64_linux:   "50ba6a89f7ac6eed4f33180a58d19385fb9253f795b5e201056fe84a5c81f84f"
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
