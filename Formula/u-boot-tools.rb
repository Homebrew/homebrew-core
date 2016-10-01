class UBootTools < Formula
  desc "Universal boot loader"
  homepage "http://www.denx.de/wiki/U-Boot/"
  url "ftp://ftp.denx.de/pub/u-boot/u-boot-2016.05.tar.bz2"
  sha256 "87d02275615aaf0cd007b54cbe9fbadceef2bee7c79e6c323ea1ae8956dcb171"

  bottle do
    cellar :any
    sha256 "85858a8abae6b79c943a85c119498d16509efd13b9989ec2d2c356f6d5e34067" => :sierra
    sha256 "0d5eb7664ca7aa6e65d0d2fb0fdfb60a72f1efd155e66af92afcd25a972d75e0" => :el_capitan
    sha256 "7cb2d54b1215be75c3e086a6800ffd00ba61cf8907e1316020f798557daf47a8" => :yosemite
    sha256 "d8d53065724d5f955ab879cbbb0bdb3c868ef267ca7c23c5a2d9fd3bf69b2fe3" => :mavericks
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
