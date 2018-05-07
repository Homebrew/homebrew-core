class UBootTools < Formula
  desc "Universal boot loader"
  homepage "https://www.denx.de/wiki/U-Boot/"
  url "http://ftp.denx.de/pub/u-boot/u-boot-2018.05.tar.bz2"
  sha256 "4da13c2a6139a78cc08608f21fd4741db27eda336cfad7ab8264fda923b9c048"

  bottle do
    cellar :any
    sha256 "9a25ab5ca27da21bdb3d08ac501183fe768f35e01e2348d294e0aa66610bae84" => :high_sierra
    sha256 "740277c82ff08c39612c984e0139c3095f3962994ba8fb84765569afaf693730" => :sierra
    sha256 "1198346b6b3afdbd2fc20d566174ab3ecd4b0f85f39d9bce155b9473ded49c82" => :el_capitan
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
