class UBootTools < Formula
  desc "Universal boot loader"
  homepage "https://www.denx.de/wiki/U-Boot/"
  url "http://ftp.denx.de/pub/u-boot/u-boot-2018.05.tar.bz2"
  sha256 "4da13c2a6139a78cc08608f21fd4741db27eda336cfad7ab8264fda923b9c048"

  bottle do
    cellar :any
    sha256 "292d6891f543f3db03c96e8b62fa754e2c452e6b1ba5c4e7fde67a9731fe2dcb" => :high_sierra
    sha256 "d6cfb2dd3794f31182cfdbe54dc73de11fda73fa1fa0548c18e46630f4f4ff1c" => :sierra
    sha256 "094486dc701036c17716113e867af69c6104b7dd3114bb10df5a02bd93777cd4" => :el_capitan
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
