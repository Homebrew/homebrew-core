class UBootTools < Formula
  desc "Universal boot loader"
  homepage "http://www.denx.de/wiki/U-Boot/"
  url "ftp://ftp.denx.de/pub/u-boot/u-boot-2016.11.tar.bz2"
  sha256 "45813e6565dcc0436abe6752624324cdbf5f3ac106570d76d32b46ec529bcdc8"

  bottle do
    cellar :any
    sha256 "c63c20ca1be8282bfa84be0656f5ce82eb1055d4bbd3f288ff1a1889a0cec624" => :sierra
    sha256 "9567f61287036de5b8eade8b0d7ff8fb8f47194f5f883a8e20574d0fad484157" => :el_capitan
    sha256 "9644b919357100d2075c2962e181e30289e081dba7a3fd0346c615905d36b8c6" => :yosemite
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
