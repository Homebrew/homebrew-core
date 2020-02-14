class UBootTools < Formula
  desc "Universal boot loader"
  homepage "https://www.denx.de/wiki/U-Boot/"
  url "https://ftp.denx.de/pub/u-boot/u-boot-2020.01.tar.bz2"
  sha256 "aa453c603208b1b27bd03525775a7f79b443adec577fdc6e8f06974025a135f1"

  bottle do
    cellar :any
    sha256 "af8a3c5ce497b01ea53fba05c2995e3614bd52f695dae88ab97d3eed675f3846" => :catalina
    sha256 "5f036981757605340697d6b5162037d786b40b2f25de56c2b5b10e7552be22b3" => :mojave
    sha256 "a90ef3a2c36fd843ce11d922ab18f2a3d4cd77d27ad013239ec5de6e4508e2f0" => :high_sierra
  end

  depends_on "openssl@1.1"

  def install
    # Replace keyword not present in make 3.81
    inreplace "Makefile", "undefine MK_ARCH", "unexport MK_ARCH"

    system "make", "sandbox_defconfig"
    system "make", "tools", "NO_SDL=1"
    bin.install "tools/mkimage"
    bin.install "tools/dumpimage"
    man1.install "doc/mkimage.1"
  end

  test do
    system bin/"mkimage", "-V"
    system bin/"dumpimage", "-V"
  end
end
