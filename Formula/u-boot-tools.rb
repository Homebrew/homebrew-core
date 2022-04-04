class UBootTools < Formula
  desc "Universal boot loader"
  homepage "https://www.denx.de/wiki/U-Boot/"
  url "https://ftp.denx.de/pub/u-boot/u-boot-2022.04.tar.bz2"
  sha256 "68e065413926778e276ec3abd28bb32fa82abaa4a6898d570c1f48fbdb08bcd0"
  license all_of: ["GPL-2.0-only", "GPL-2.0-or-later", "BSD-3-Clause"]

  livecheck do
    url "https://ftp.denx.de/pub/u-boot/"
    regex(/href=.*?u-boot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "540ca23af7b3630dba1033ca61fd38b14010c9a3f85d68b6831fae853419b1d1"
    sha256 cellar: :any,                 arm64_big_sur:  "9a7e2c34ded817c84bc1fb3fc48c24f1328981e1b249b9a5a8136220e3dbb8fe"
    sha256 cellar: :any,                 monterey:       "6450fd699e181bfdf425e0589e4229f393eb2de18f1129813596f27cc6e8b482"
    sha256 cellar: :any,                 big_sur:        "e0d92420fc18761ba5d57fc6673c32a0a15b6f2fc53d157710a342f0ed5becc1"
    sha256 cellar: :any,                 catalina:       "d900a6999720ab8f639315dac583e84096d96114d6f247f7e9cbd1cb7c7c2443"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a448c182c1e5929fb71642fd0a7a9674430ab003f363d6974ecdcc5eeef3c000"
  end

  depends_on "coreutils" => :build # Makefile needs $(gdate)
  depends_on "openssl@1.1"

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
