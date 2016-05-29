class UBootTools < Formula
  desc "Universal boot loader"
  homepage "http://www.denx.de/wiki/U-Boot/"
  url "ftp://ftp.denx.de/pub/u-boot/u-boot-2016.05.tar.bz2"
  sha256 "87d02275615aaf0cd007b54cbe9fbadceef2bee7c79e6c323ea1ae8956dcb171"

  bottle do
    cellar :any
    sha256 "c2a92d9d9d4ef010efcc37e9b63ac2ea6eee320a4350d9aa6188f43d86898f7b" => :el_capitan
    sha256 "7b6c473cd6c1ced723207643272a130a7e08f3f0ccc1694a94c12c34e3c5ea50" => :yosemite
    sha256 "881cbe663a6c63ab8bf6e0b41c20354a2030177ec320f9c85ed9dc98e2f9e551" => :mavericks
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
