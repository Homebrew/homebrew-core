class UBootTools < Formula
  desc "Universal boot loader"
  homepage "http://www.denx.de/wiki/U-Boot/"
  url "ftp://ftp.denx.de/pub/u-boot/u-boot-2017.03.tar.bz2"
  sha256 "f54baf3f9325bf444c7905f3a5b6f83680edb1e6e1a4d5f8a5ad80abe885113f"

  bottle do
    cellar :any
    sha256 "5294bc120061f782522562f4c52c2a3b101a5cb995b48048efcbda69a7f2c5cf" => :sierra
    sha256 "8d9aeda40aba937d4363192d926487425c940d695b16d19bb23e07394f63d756" => :el_capitan
    sha256 "51e824bfac4532dfffda4a44e91cee69e7b6504897f4c184c36ce253ad2ee738" => :yosemite
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
