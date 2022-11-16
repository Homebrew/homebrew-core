class UBootTools < Formula
  desc "Universal boot loader"
  homepage "https://www.denx.de/wiki/U-Boot/"
  url "https://ftp.denx.de/pub/u-boot/u-boot-2022.10.tar.bz2"
  sha256 "50b4482a505bc281ba8470c399a3c26e145e29b23500bc35c50debd7fa46bdf8"
  license all_of: ["GPL-2.0-only", "GPL-2.0-or-later", "BSD-3-Clause"]

  livecheck do
    url "https://ftp.denx.de/pub/u-boot/"
    regex(/href=.*?u-boot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "a5c755402325271f4d814154e572295ffc79a2d3ab9d551d564743ea519b547e"
    sha256 cellar: :any,                 arm64_monterey: "fcf481e76ad286781a9e74b2395a263def5382c6c0e6d29a7a0dfcd7255decbf"
    sha256 cellar: :any,                 arm64_big_sur:  "35e09390026f8dd3b12a7781bc93e5a0c6314844d622e1d8e91913997cf6be06"
    sha256 cellar: :any,                 monterey:       "67df4d2ddfa5dea5250bbefb453f5947a5f886bbb75aceb4a7dfdaf69ae685a6"
    sha256 cellar: :any,                 big_sur:        "b2354f8b5f468df0dd4f0a4d00049867eb68ca08d0bc7e069c63b3f13ad690f6"
    sha256 cellar: :any,                 catalina:       "020d650fbcc7230aad7b0243d08889a551449cb842369dfd5488960a3be6550d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b0a42eb62c6259aec9a98faaacf46854972099dd3418631d67a61ac85e1cce9"
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
