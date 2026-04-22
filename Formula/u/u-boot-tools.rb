class UBootTools < Formula
  desc "Universal boot loader"
  homepage "https://www.denx.de/wiki/U-Boot/"
  url "https://ftp.denx.de/pub/u-boot/u-boot-2026.04.tar.bz2"
  sha256 "ac7c04b8b7004923b00a4e5d6699c5df4d21233bac9fda690d8cfbc209fff2fd"
  license all_of: ["GPL-2.0-only", "GPL-2.0-or-later", "BSD-3-Clause"]

  livecheck do
    url "https://ftp.denx.de/pub/u-boot/"
    regex(/href=.*?u-boot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a9ca64f16581d0f3c90d1b39b20f3d94e07bca1c8a65a40cdaca63171e73c431"
    sha256 cellar: :any,                 arm64_sequoia: "a5886b8319d63b74bff1fe8786cace9aafd69f83d610acaafb14eba93ee89bc2"
    sha256 cellar: :any,                 arm64_sonoma:  "db49877c14f39a27e753b3851204ddd6b5b58ef1b47ec88355f002b3f30133fb"
    sha256 cellar: :any,                 sonoma:        "85656af6c548d88e472b97dcfeec8f36d83c19b4e634da9246309c1054ee12ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f74ae017b09cfb0be45813a77e93d5d56bfcc23004f49e6c2df2c225dcb3d48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "212eba5d4045ea47b8522a0a0c5aae4fabab8c2d8e94cfdf20b211290b4151d5"
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
