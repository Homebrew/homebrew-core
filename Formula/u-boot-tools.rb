class UBootTools < Formula
  desc "Universal boot loader"
  homepage "https://www.denx.de/wiki/U-Boot/"
  url "https://ftp.denx.de/pub/u-boot/u-boot-2021.07.tar.bz2"
  sha256 "312b7eeae44581d1362c3a3f02c28d806647756c82ba8c72241c7cdbe68ba77e"
  license all_of: ["GPL-2.0-only", "GPL-2.0-or-later", "BSD-3-Clause"]

  livecheck do
    url "https://ftp.denx.de/pub/u-boot/"
    regex(/href=.*?u-boot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "795b546108fe9bb26d5f19105722f5d4004f8f7cb607b4c5c22ef00001aab494"
    sha256 cellar: :any,                 big_sur:       "14ec1c7ecbd9f2988b5375684d7808eb1eee0c3b96f21eaf0525993f770d9eb4"
    sha256 cellar: :any,                 catalina:      "c47f93bad1f4dc106528afd47a6c5d2f1a840c4de8ad4b6bc8c23ebd74d2b444"
    sha256 cellar: :any,                 mojave:        "4123e118d4c499416fabdedd1e6e3ba4c097b5aa494832b8894c08193dfda26d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc4d6167a0f8770ee60cc2d33d31ac664ee021f33f09065b4fd9fba96bbeb12c"
  end

  depends_on "coreutils" => :build # Makefile needs $(gdate)
  depends_on "openssl@1.1"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    # Replace keyword not present in make 3.81
    inreplace "Makefile", "undefine MK_ARCH", "unexport MK_ARCH"

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
