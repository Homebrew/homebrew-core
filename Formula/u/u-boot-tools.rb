class UBootTools < Formula
  desc "Universal boot loader"
  homepage "https://www.denx.de/wiki/U-Boot/"
  url "https://ftp.denx.de/pub/u-boot/u-boot-2023.07.02.tar.bz2"
  sha256 "6b6a48581c14abb0f95bd87c1af4d740922406d7b801002a9f94727fdde021d5"
  license all_of: ["GPL-2.0-only", "GPL-2.0-or-later", "BSD-3-Clause"]

  livecheck do
    url "https://ftp.denx.de/pub/u-boot/"
    regex(/href=.*?u-boot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c095e9d8fe0182d7b2b716fd3993f8863c470d8976444239a844da7a29dcfb2b"
    sha256 cellar: :any,                 arm64_monterey: "77931ba3583520b3a00f6fee3fa5b231e810006e91ae175f246c51cbe79b3fd4"
    sha256 cellar: :any,                 arm64_big_sur:  "3c47a8fe64d6a1ce648a5ab17df2b1148a1102c11216eae49f625a9ce9c2f33e"
    sha256 cellar: :any,                 ventura:        "bfd54176e94ffd2ad380ab7cbd25e091afe9338b17343881cd957f5f6c30d5ed"
    sha256 cellar: :any,                 monterey:       "4038918e0502cf293b33665cf2f987f5090b24421a7203bd30e65d0641c85cc4"
    sha256 cellar: :any,                 big_sur:        "1bb8af4d4f9933e3187b00fb20adca84e558ed1ea8c26279177f5ba45330e032"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc7dade81bd1decd1441fb81233410e1949da76c76ecc4eb6a1f5d6b41e463ad"
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
