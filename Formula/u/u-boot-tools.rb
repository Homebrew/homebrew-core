class UBootTools < Formula
  desc "Universal boot loader"
  homepage "https://www.denx.de/wiki/U-Boot/"
  url "https://ftp.denx.de/pub/u-boot/u-boot-2024.10.tar.bz2"
  sha256 "b28daf4ac17e43156363078bf510297584137f6df50fced9b12df34f61a92fb0"
  license all_of: ["GPL-2.0-only", "GPL-2.0-or-later", "BSD-3-Clause"]

  livecheck do
    url "https://ftp.denx.de/pub/u-boot/"
    regex(/href=.*?u-boot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bf2a5afadede8038a3680ad3f90b1809e237232c9b4f32a2a8dd9fab5b9c1de0"
    sha256 cellar: :any,                 arm64_sonoma:  "374be00979264065310954f77ff8b3f78033febc10589ebcace542ef29307fd0"
    sha256 cellar: :any,                 arm64_ventura: "14eed409bbe0ebe72c9a504508c00f6c1c69b4b7a271585244831716fe801a54"
    sha256 cellar: :any,                 sonoma:        "0b3a53c111cdb47c90058d69e92cf1ca5975704a36e090b7b4d42217bf9dfedf"
    sha256 cellar: :any,                 ventura:       "225fdab56e59044069af8967f99532a145f7da0d26e6ca233a555abfe2e87437"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8117ff616a7175008d1cf21143a95953bcc3df977d3edcbe00fd647f741ef25b"
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
