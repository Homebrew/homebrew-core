class UBootTools < Formula
  desc "Universal boot loader"
  homepage "https://www.denx.de/wiki/U-Boot/"
  url "https://ftp.denx.de/pub/u-boot/u-boot-2019.07.tar.bz2"
  sha256 "bff4fa77e8da17521c030ca4c5b947a056c1b1be4d3e6ee8637020b8d50251d0"
  revision 1

  bottle do
    cellar :any
    sha256 "12b0fc3efe3bc1cb8bc8601961312b5cc0f06c0763f7e8ef498c6b67c51bb914" => :mojave
    sha256 "7ce886985cd7618286df58f5b81db5122a20e32a31463ee09f2231adece1646a" => :high_sierra
    sha256 "d773f7288db6b6e29d421b64c237f9b3cdc2fa67c1cca63d5f1aaa2160eea424" => :sierra
  end

  depends_on "openssl@1.1"

  def install
    system "make", "sandbox_defconfig"
    system "make", "tools"
    bin.install "tools/mkimage"
    bin.install "tools/dumpimage"
    man1.install "doc/mkimage.1"
  end

  test do
    system bin/"mkimage", "-V"
    system bin/"dumpimage", "-V"
  end
end
