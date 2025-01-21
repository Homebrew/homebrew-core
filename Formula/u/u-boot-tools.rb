class UBootTools < Formula
  desc "Universal boot loader"
  homepage "https://www.denx.de/wiki/U-Boot/"
  url "https://ftp.denx.de/pub/u-boot/u-boot-2025.01.tar.bz2"
  sha256 "cdef7d507c93f1bbd9f015ea9bc21fa074268481405501945abc6f854d5b686f"
  license all_of: ["GPL-2.0-only", "GPL-2.0-or-later", "BSD-3-Clause"]

  livecheck do
    url "https://ftp.denx.de/pub/u-boot/"
    regex(/href=.*?u-boot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e3af1e733cc25f6cc0db2b31f8a33d7ddd7da9c0e6d79f12f5e9f98b386601d6"
    sha256 cellar: :any,                 arm64_sonoma:  "f61adaca6d7ad95258f3160cf77bf221441cb9f91c38ff3b2894896c63aea1ac"
    sha256 cellar: :any,                 arm64_ventura: "aa38563c59c86ab33db3a2864537bc9fbf72ea72d49b1fb12cc424d2ca85e00c"
    sha256 cellar: :any,                 sonoma:        "7be5860e67810bf70834da86d2f566cdd3c90e0ffbd48b1810d3620a5ee0e213"
    sha256 cellar: :any,                 ventura:       "db7c955a415600be01bf26bf9ba872434ce4f91b0f32f99afbd1a0a970d16e1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2694e880482166e36ba025ff90094123f273549b1af8d3526255896c58f3d15d"
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
