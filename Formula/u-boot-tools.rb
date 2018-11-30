class UBootTools < Formula
  desc "Universal boot loader"
  homepage "https://www.denx.de/wiki/U-Boot/"
  url "http://ftp.denx.de/pub/u-boot/u-boot-2018.07.tar.bz2"
  sha256 "9f10df88bc91b35642e461217f73256bbaeeca9ae2db8db56197ba5e89e1f6d4"

  bottle do
    cellar :any
    sha256 "2a61d2b7b9dc8a9e242db1d089ecd65ee47dee4b2a29b1503f11e751598b900f" => :mojave
    sha256 "a40ea4b2bdf0f635900646f460f709198c61fdf93940d3ff99eec6b09a6b71a5" => :high_sierra
    sha256 "f3027edb62b61fd54ba7e59787e4889de71d05507819feb700c8b683afdbe85e" => :sierra
    sha256 "09855b71f13bd90be588002c3133783a9bb96c7f9ca2ea193e88dcacf5357a14" => :el_capitan
  end

  depends_on "openssl"

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
