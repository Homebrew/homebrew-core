class UBootTools < Formula
  desc "Universal boot loader"
  homepage "https://www.denx.de/wiki/U-Boot/"
  url "http://ftp.denx.de/pub/u-boot/u-boot-2017.11.tar.bz2"
  sha256 "6a018fd3caf58f3dcfa23ee989a82bd35df03af71872b9dca8c6d758a0d26c05"

  bottle do
    cellar :any
    sha256 "69accce4faa7c9375b8366906f1144e7da4f32e6d7f8df25c4c9bb3eabfd9f2d" => :high_sierra
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
