class UBootTools < Formula
  desc "Universal boot loader"
  homepage "https://www.denx.de/wiki/U-Boot/"
  url "https://ftp.denx.de/pub/u-boot/u-boot-2020.04.tar.bz2"
  sha256 "fe732aaf037d9cc3c0909bad8362af366ae964bbdac6913a34081ff4ad565372"

  bottle do
    cellar :any
    sha256 "bfbf1bae659e2da917d7839cd71584af6c4908f64a2be71def873c65e8a5578a" => :catalina
    sha256 "8bb5bdd813f60c047610f356636bc6167a09a4f13827453087e59fc29dbf1871" => :mojave
    sha256 "0cc829f876955bcd937e3ff793270b74819d07efba9ef6fd04bd1d7d538edd1b" => :high_sierra
  end

  depends_on "openssl@1.1"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

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
