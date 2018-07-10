class UBootTools < Formula
  desc "Universal boot loader"
  homepage "https://www.denx.de/wiki/U-Boot/"
  url "http://ftp.denx.de/pub/u-boot/u-boot-2018.07.tar.bz2"
  sha256 "9f10df88bc91b35642e461217f73256bbaeeca9ae2db8db56197ba5e89e1f6d4"

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
