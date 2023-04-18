class UBootTools < Formula
  desc "Universal boot loader"
  homepage "https://www.denx.de/wiki/U-Boot/"
  url "https://ftp.denx.de/pub/u-boot/u-boot-2023.04.tar.bz2"
  sha256 "e31cac91545ff41b71cec5d8c22afd695645cd6e2a442ccdacacd60534069341"
  license all_of: ["GPL-2.0-only", "GPL-2.0-or-later", "BSD-3-Clause"]

  livecheck do
    url "https://ftp.denx.de/pub/u-boot/"
    regex(/href=.*?u-boot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "bfa7a6a9ac4ec14b977a21a3d32035708d617074e3bd878cfb284588e5e603a8"
    sha256 cellar: :any,                 arm64_monterey: "9f0b461518c2c73118c1bc84bf6e4aed03c7c9498578805076586535573ca422"
    sha256 cellar: :any,                 arm64_big_sur:  "433087d71ad0e17f7f8866b3e377f84b6464c2b1003c7300615dcca673c04d59"
    sha256 cellar: :any,                 ventura:        "1f99864ae4bab7a1223499b23c91badd0ceefb3e65498259b0ab1bbf8685897b"
    sha256 cellar: :any,                 monterey:       "d9441454506ac196e7ca0b86867cdd2b28e64efc845f37674448382d01548dba"
    sha256 cellar: :any,                 big_sur:        "e41ab1d01c6417bf0a44c539730ce22ee3aeb3488d4b61bc8341de079cbd2839"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5cb01790674bf26ec170cba5bd7446334e24776a26d538ef21adf4eff5bace0"
  end

  depends_on "coreutils" => :build # Makefile needs $(gdate)
  depends_on "openssl@3"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    # Replace keyword not present in make 3.81
    inreplace "Makefile", "undefine MK_ARCH", "unexport MK_ARCH"

    # Disable mkeficapsule
    inreplace "configs/tools-only_defconfig", "CONFIG_TOOLS_MKEFICAPSULE=y", "CONFIG_TOOLS_MKEFICAPSULE=n"

    system "make", "tools-only_defconfig"
    system "make", "tools-only", "NO_SDL=1"
    bin.install "tools/mkimage"
    bin.install "tools/dumpimage"
    man1.install "doc/mkimage.1"
  end

  test do
    system bin/"mkimage", "-V"
    system bin/"dumpimage", "-V"
  end
end
