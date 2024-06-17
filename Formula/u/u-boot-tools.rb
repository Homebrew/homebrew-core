class UBootTools < Formula
  desc "Universal boot loader"
  homepage "https://www.denx.de/wiki/U-Boot/"
  url "https://ftp.denx.de/pub/u-boot/u-boot-2024.04.tar.bz2"
  sha256 "18a853fe39fad7ad03a90cc2d4275aeaed6da69735defac3492b80508843dd4a"
  license all_of: ["GPL-2.0-only", "GPL-2.0-or-later", "BSD-3-Clause"]

  livecheck do
    url "https://ftp.denx.de/pub/u-boot/"
    regex(/href=.*?u-boot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "862a0df6bbb7fbdc7044d65a4e672154b4a177822df2f4f110a32a857180aa3f"
    sha256 cellar: :any,                 arm64_ventura:  "e6728df795af1cbe03477553791c64d8c34c952c55845f2a12aff1c7088bc51f"
    sha256 cellar: :any,                 arm64_monterey: "f13bbc7fe62f5b27a6cf3872dd3770484d5ba5c3f278bc84c75b2e433dc683af"
    sha256 cellar: :any,                 sonoma:         "b7193b90808e1833b61193a531f561147209ab81553332316819d2b6e0b70d36"
    sha256 cellar: :any,                 ventura:        "cf5cd45aa95b28b4bbade5d8c2ffef413afa53d04e2d96627274ab7b08962103"
    sha256 cellar: :any,                 monterey:       "473dc4843a71a1042c4d102a3964a8528df91536ea1d2ac3003e3ae4dfd764bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b2fde53be6aa17248f7dd325d373111d8972e50d91f4384e5d3a77917b0c926"
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
