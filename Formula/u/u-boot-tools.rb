class UBootTools < Formula
  desc "Universal boot loader"
  homepage "https://www.denx.de/wiki/U-Boot/"
  url "https://ftp.denx.de/pub/u-boot/u-boot-2026.07.tar.bz2"
  sha256 "78e8bfc382fe388f9b55aa1daf8c563522a037779b5d4c349d1415e381f1243e"
  license all_of: ["GPL-2.0-only", "GPL-2.0-or-later", "BSD-3-Clause"]

  livecheck do
    url "https://ftp.denx.de/pub/u-boot/"
    regex(/href=.*?u-boot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ea87d08776a7558bc088e0980bd4ffa5a909f32a8b87a02c3f0abce5169d6a01"
    sha256 cellar: :any, arm64_sequoia: "489b685038756e004ae0c3fa37b7c39f1e2a3746d1cbe33f9c200182b913f190"
    sha256 cellar: :any, arm64_sonoma:  "a9bda8ec3ce0a54fe3f2e88ae1d24bb19763ce9f600cead8852d0a0333430724"
    sha256 cellar: :any, sonoma:        "d8c740f96f87129cb241298427efbc2a424b31b4ee529cf02b65ba11c78296df"
    sha256 cellar: :any, arm64_linux:   "477a60d03ccb7634e37dba8dea6ff001cdae5492bfdc3beafc6642e44bbb700f"
    sha256 cellar: :any, x86_64_linux:  "04c316e3bf4ed2cf6dd25300418022eb7485902eb8b99a8497d1b951a2acb158"
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
    bin.install "tools/mkenvimage"
    man1.install "doc/mkimage.1"
  end

  test do
    system bin/"mkimage", "-V"
    system bin/"dumpimage", "-V"
    system bin/"mkenvimage", "-V"
  end
end
