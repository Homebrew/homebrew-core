class UBootTools < Formula
  desc "Universal boot loader"
  homepage "https://www.denx.de/wiki/U-Boot/"
  url "https://ftp.denx.de/pub/u-boot/u-boot-2019.07.tar.bz2"
  sha256 "bff4fa77e8da17521c030ca4c5b947a056c1b1be4d3e6ee8637020b8d50251d0"
  revision 1

  bottle do
    cellar :any
    sha256 "d8ed22b53de5ef5e3838383676c4f3a98ba2d0b1426d642ae966695776e24ded" => :mojave
    sha256 "19bb4b4cb1a75cdff0f03545d9a343d21159881b7db79bf1efc05c1093b5d371" => :high_sierra
    sha256 "700555f219bb29d8b01676e0c7c77d3603acdc4f8384d3ac4f322fbc621104dd" => :sierra
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
