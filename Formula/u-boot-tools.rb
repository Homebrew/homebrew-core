class UBootTools < Formula
  desc "Universal boot loader"
  homepage "https://www.denx.de/wiki/U-Boot/"
  url "http://ftp.denx.de/pub/u-boot/u-boot-2018.03.tar.bz2"
  sha256 "7e7477534409d5368eb1371ffde6820f0f79780a1a1f676161c48442cb303dfd"

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
