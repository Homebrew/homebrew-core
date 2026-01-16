class UBootTools < Formula
  desc "Universal boot loader"
  homepage "https://www.denx.de/wiki/U-Boot/"
  url "https://ftp.denx.de/pub/u-boot/u-boot-2026.01.tar.bz2"
  sha256 "b60d5865cefdbc75da8da4156c56c458e00de75a49b80c1a2e58a96e30ad0d54"
  license all_of: ["GPL-2.0-only", "GPL-2.0-or-later", "BSD-3-Clause"]

  livecheck do
    url "https://ftp.denx.de/pub/u-boot/"
    regex(/href=.*?u-boot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "88479294771ca0eb46089a2d4c8f587ab4aae4c6d9bb3d36873862148beb6837"
    sha256 cellar: :any,                 arm64_sequoia: "278278c783544f5edca4bff2862499af8a0ec500f7a6ffc495b5c6765cedec5e"
    sha256 cellar: :any,                 arm64_sonoma:  "85267b211db10cdb89d2afd4b098f43501beb921da8fcbf0755b28aaf2cbad38"
    sha256 cellar: :any,                 sonoma:        "f38775bf05bd5991b1d1bf5c0b105cf276ea782037e11b1e091badacc1777842"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06daa7f7fa4fd38bd3f7d4f587e49ad3539c769d7b00586be1cd0f4086fa451c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "999e0af3ac7448b1c8d8eb2c36afb58985e27b9f4057b4aab2151c7e952a7bdc"
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
