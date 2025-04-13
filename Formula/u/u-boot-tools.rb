class UBootTools < Formula
  desc "Universal boot loader"
  homepage "https://www.denx.de/wiki/U-Boot/"
  url "https://ftp.denx.de/pub/u-boot/u-boot-2025.04.tar.bz2"
  sha256 "439d3bef296effd54130be6a731c5b118be7fddd7fcc663ccbc5fb18294d8718"
  license all_of: ["GPL-2.0-only", "GPL-2.0-or-later", "BSD-3-Clause"]

  livecheck do
    url "https://ftp.denx.de/pub/u-boot/"
    regex(/href=.*?u-boot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d637234bc774fd2bcd700a28b5d8ed78b49a38af55b2e47c33d6320a67f02937"
    sha256 cellar: :any,                 arm64_sonoma:  "da971cb9ddcd87fba57fc44c8c199653015ac8110339a4ff2bb63db6fa6082c5"
    sha256 cellar: :any,                 arm64_ventura: "d668af19b960369ebf3e73293783c66d6877d814b23b4bb32f5c809782bd4b50"
    sha256 cellar: :any,                 sonoma:        "018b14fb4513bead191c26f6f4d73fccfca1f429aa1d8c2ef921dea5caf7f0fb"
    sha256 cellar: :any,                 ventura:       "b1a474154e348e0baf8e01ee305d49ae753e845343c2ad89813ab45380f4a559"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d49f5501359ff51c4a3e8cb3ddf805e4a5736a575c1f64337a97b88ef434e04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75ce030253d231e96f336c363480733f6d917b883af0e1d2f7f67dd573fad0f2"
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
