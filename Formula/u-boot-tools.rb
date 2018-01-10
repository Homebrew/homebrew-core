class UBootTools < Formula
  desc "Universal boot loader"
  homepage "https://www.denx.de/wiki/U-Boot/"
  url "http://ftp.denx.de/pub/u-boot/u-boot-2018.01.tar.bz2"
  sha256 "938f597394b33e82e5af8c98bd5ea1a238f61892aabef36384adbf7ca5b52dda"

  bottle do
    cellar :any
    sha256 "cd5663b4ca5e3d25eb2702e2c8abaae54946ef34fd45e62bac6146c6b7c9e687" => :high_sierra
    sha256 "0cc15099ae1e45facf124f8ccb3e49be2ea0f81ba60f33039c7b16ffec92d9e5" => :sierra
    sha256 "81e15d2aee2ab3e413f632c4cc6cc3180f5e48b74e1fa0a59ad6f623f79a0c64" => :el_capitan
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
