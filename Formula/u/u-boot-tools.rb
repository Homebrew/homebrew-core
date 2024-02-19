class UBootTools < Formula
  desc "Universal boot loader"
  homepage "https://www.denx.de/wiki/U-Boot/"
  url "https://ftp.denx.de/pub/u-boot/u-boot-2024.01.tar.bz2"
  sha256 "b99611f1ed237bf3541bdc8434b68c96a6e05967061f992443cb30aabebef5b3"
  license all_of: ["GPL-2.0-only", "GPL-2.0-or-later", "BSD-3-Clause"]

  livecheck do
    url "https://ftp.denx.de/pub/u-boot/"
    regex(/href=.*?u-boot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "72acc1370e5818d6e002af65c294e44ce0d2b7bb73a5d7da9243278179c1ba40"
    sha256 cellar: :any,                 arm64_ventura:  "54e1c86be24ad69751d0ce55f71f05449c302d9c339ab97684d23d9dee3271c9"
    sha256 cellar: :any,                 arm64_monterey: "6be0cab1d742972134fe9fc84201e8bcecd4136298709cf1a3bd673f777a3fe3"
    sha256 cellar: :any,                 sonoma:         "cb7b4d5709ab86be1b15f4aaeec3e5a32766432c4b26f52ae890eda70b68d73b"
    sha256 cellar: :any,                 ventura:        "7898eb640773be2ecbee353e691a509436084c62e63439fedb40b053564389d6"
    sha256 cellar: :any,                 monterey:       "c18c4c1239ae9dd933148401851eebecde90a161cd363e556279c666e9063353"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d81689320e637630a507654add3534758ca272d3ee723ba598173318299a8519"
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
