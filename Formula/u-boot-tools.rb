class UBootTools < Formula
  desc "Universal boot loader"
  homepage "https://www.denx.de/wiki/U-Boot/"
  url "http://ftp.denx.de/pub/u-boot/u-boot-2017.11.tar.bz2"
  sha256 "6a018fd3caf58f3dcfa23ee989a82bd35df03af71872b9dca8c6d758a0d26c05"

  bottle do
    cellar :any
    sha256 "6e492a2d046bdeca3a1a38bc30d1561ac120166e7cca337511213faa97f91464" => :high_sierra
    sha256 "fbdcc3d421b2bc9688a9bdf2424197d1d252a07973830939f426a8c770ad0723" => :sierra
    sha256 "7f61750a0b7871fe3249520cb5ccec3a64836f24045ca3747d506dcd7a099188" => :el_capitan
  end

  depends_on "openssl"

  def install
    system "make", "sandbox_defconfig"
    system "make", "tools"
    bin.install "tools/mkimage"
    man1.install "doc/mkimage.1"
  end

  test do
    system bin/"mkimage", "-V"
  end
end
