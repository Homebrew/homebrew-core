class UBootTools < Formula
  desc "Universal boot loader"
  homepage "https://www.denx.de/wiki/U-Boot/"
  url "https://ftp.denx.de/pub/u-boot/u-boot-2024.07.tar.bz2"
  sha256 "f591da9ab90ef3d6b3d173766d0ddff90c4ed7330680897486117df390d83c8f"
  license all_of: ["GPL-2.0-only", "GPL-2.0-or-later", "BSD-3-Clause"]

  livecheck do
    url "https://ftp.denx.de/pub/u-boot/"
    regex(/href=.*?u-boot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "92cf10af76b9a6e8e82f0713cf25ccfd6e50b4bde1148b9788f49854e83c26fc"
    sha256 cellar: :any,                 arm64_ventura:  "f14da0eae7bcfdd148af44a90f90fa45d83dfef0ed2b0afa1ed6c02afa36d3fa"
    sha256 cellar: :any,                 arm64_monterey: "1f216d648aefba66c57cfadb812bbefaf57a4da86c336446dc634c2110193049"
    sha256 cellar: :any,                 sonoma:         "523db56054b06bdede52712f043c28dbdc6b4d9644d9d93a44049614615b874e"
    sha256 cellar: :any,                 ventura:        "d0fb44c91a4e1875e971959619ce190fd65b348f002d708147447f69a65827ed"
    sha256 cellar: :any,                 monterey:       "7fca4e4bb1641e31ae201116e9e01d4b1ab00c0cb15a2326afdfbd2079fda640"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba60436b4aac58e716c7de2c18c3d28104636891139f909efb13ffafbd7e0c1c"
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
