class UBootTools < Formula
  desc "Universal boot loader"
  homepage "https://www.denx.de/wiki/U-Boot/"
  url "https://ftp.denx.de/pub/u-boot/u-boot-2021.01.tar.bz2"
  sha256 "b407e1510a74e863b8b5cb42a24625344f0e0c2fc7582d8c866bd899367d0454"
  license all_of: ["GPL-2.0-only", "GPL-2.0-or-later", "BSD-3-Clause"]

  livecheck do
    url "https://ftp.denx.de/pub/u-boot/"
    regex(/href=.*?u-boot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "38d66ae4e6d926bc35e4eb833f6810a367f2cf3cdd8ec5185a861daadc30743e" => :big_sur
    sha256 "c4e1c77a34e57576f9ab599781be090820a4d5911f4147e10d0e99114cd3c8c6" => :catalina
    sha256 "44d21cc3ac974b0538d24d4e5a74f25e3df764c8b5fc3458214890bacfa138ac" => :mojave
    sha256 "afb5dea722a9ae646809a3c8b59dbbd80b55042e3c3de8f45741e6ebb460df6a" => :high_sierra
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
