class Scummvm < Formula
  desc "Graphic adventure game interpreter"
  homepage "https://www.scummvm.org/"
  url "https://downloads.scummvm.org/frs/scummvm/2.2.0/scummvm-2.2.0.tar.xz"
  sha256 "1469657e593bd8acbcfac0b839b086f640ebf120633e93f116cab652b5b27387"
  license "GPL-2.0-or-later"
  head "https://github.com/scummvm/scummvm.git"

  livecheck do
    url "https://www.scummvm.org/frs/scummvm/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["']}i)
  end

  bottle do
    sha256 "bfdd3aa29ce7738729b03c1c58844a9085df58de2e8042db880519dcb3d61aeb" => :big_sur
    sha256 "b48fb222871740414480cb4a1789c1c1b379b30dafac2970656ec8802deb205b" => :catalina
    sha256 "0e359a79ab9835cd3511d1aa7e617349b50fcb0a3241c2d700d2341f321a90b7" => :mojave
    sha256 "dafe75e762c2ccee797055f3bf6dda13d08f3e1efcd2c7017dc734db41a1acef" => :high_sierra
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
    (share+"pixmaps").rmtree
    (share+"icons").rmtree
  end

  test do
    system "#{bin}/scummvm", "-v"
  end
end
