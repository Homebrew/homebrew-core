class Scummvm < Formula
  desc "Graphic adventure game interpreter"
  homepage "https://www.scummvm.org/"
  url "https://downloads.scummvm.org/frs/scummvm/2.2.0/scummvm-2.2.0.tar.xz"
  sha256 "1469657e593bd8acbcfac0b839b086f640ebf120633e93f116cab652b5b27387"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/scummvm/scummvm.git", branch: "master"

  livecheck do
    url "https://www.scummvm.org/downloads/"
    regex(/href=.*?scummvm[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "f446b713a5390ddb37f57de1dafad4b0a5fec77af75f65bf4b3f1c81d70d193d"
    sha256 big_sur:       "f1e3edd576feee9c8360d2276a4ec1821826f32f31675c2d6f3fbe4f3dc4e594"
    sha256 catalina:      "fa569b125a50401242cdc26b27b1c01edde13555aa3018eeb81bc5cb910581e9"
    sha256 mojave:        "ad5d75fffe9d076923c42bc813b43db5a2088270f5c21266ce8850dfaa67d4d8"
    sha256 x86_64_linux:  "070825713586af1f3f591c3318ce78d4a62fc6c52c24a1e39b99bdb58823cc44"
  end

  depends_on "a52dec"
  depends_on "faad2"
  depends_on "flac"
  depends_on "fluid-synth@2.1"
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
    (share+"pixmaps").rmtree
    (share+"icons").rmtree
  end

  test do
    on_linux do
      # Test fails on headless CI: Could not initialize SDL: No available video device
      return if ENV["HOMEBREW_GITHUB_ACTIONS"]
    end

    system "#{bin}/scummvm", "-v"
  end
end
