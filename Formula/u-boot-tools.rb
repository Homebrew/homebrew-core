class UBootTools < Formula
  desc "Universal boot loader"
  homepage "https://www.denx.de/wiki/U-Boot/"
  url "https://ftp.denx.de/pub/u-boot/u-boot-2019.10.tar.bz2"
  sha256 "8d6d6070739522dd236cba7055b8736bfe92b4fac0ea18ad809829ca79667014"

  bottle do
    cellar :any
    sha256 "57e03729a3ec9b9b3b9254251e6ee33e9e2b208f2eea0e8d056deed610670324" => :catalina
    sha256 "12b0fc3efe3bc1cb8bc8601961312b5cc0f06c0763f7e8ef498c6b67c51bb914" => :mojave
    sha256 "7ce886985cd7618286df58f5b81db5122a20e32a31463ee09f2231adece1646a" => :high_sierra
    sha256 "d773f7288db6b6e29d421b64c237f9b3cdc2fa67c1cca63d5f1aaa2160eea424" => :sierra
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
