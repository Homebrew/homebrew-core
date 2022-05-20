class UBootTools < Formula
  desc "Universal boot loader"
  homepage "https://www.denx.de/wiki/U-Boot/"
  url "https://ftp.denx.de/pub/u-boot/u-boot-2022.04.tar.bz2"
  sha256 "68e065413926778e276ec3abd28bb32fa82abaa4a6898d570c1f48fbdb08bcd0"
  license all_of: ["GPL-2.0-only", "GPL-2.0-or-later", "BSD-3-Clause"]

  livecheck do
    url "https://ftp.denx.de/pub/u-boot/"
    regex(/href=.*?u-boot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c545e0aadb914f5b535149ce3423fcbafa5f7931b514ed630e9518a65862116f"
    sha256 cellar: :any,                 arm64_big_sur:  "f3d13f8b5f7cbda3a7714a70eb05a2f2026972de55735de95e58b8df2d43dac8"
    sha256 cellar: :any,                 monterey:       "6028f04c201c11d97174bc4a03a7a84fe6c58cf013ed8f1e3fab873db1329541"
    sha256 cellar: :any,                 big_sur:        "a7b15c98c78d8527fe852a8a8416f5ead7016515c31e8d537e22bb0448540e8c"
    sha256 cellar: :any,                 catalina:       "f42d910896dcccb113a2d3749ab727b48c5d267180d6bcf71d2049f171796c43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1dea488937c1c9374a39d0bb07cb376079da1860fdbd1c6b9e70a6290648188e"
  end

  depends_on "coreutils" => :build # Makefile needs $(gdate)
  depends_on "openssl@1.1"

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
