class UBootTools < Formula
  desc "Universal boot loader"
  homepage "https://www.denx.de/wiki/U-Boot/"
  url "https://ftp.denx.de/pub/u-boot/u-boot-2023.01.tar.bz2"
  sha256 "69423bad380f89a0916636e89e6dcbd2e4512d584308d922d1039d1e4331950f"
  license all_of: ["GPL-2.0-only", "GPL-2.0-or-later", "BSD-3-Clause"]

  livecheck do
    url "https://ftp.denx.de/pub/u-boot/"
    regex(/href=.*?u-boot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "86f5fb6951574b141ee0ea465b8759f8c1bf74f2923b31f3255b538c2018b169"
    sha256 cellar: :any,                 arm64_monterey: "a9292cad9a18732e7e5dad5538b77229f2948f3f7f4abeab4a36e378990ad84c"
    sha256 cellar: :any,                 arm64_big_sur:  "38b1c11d6d43682b7281710a9b83c4683847888d9f22b95c779f648323fbecb6"
    sha256 cellar: :any,                 ventura:        "efba6d093186508ca06f9db3f7315afe951bbd7b525ee22b19f19c3a592f827d"
    sha256 cellar: :any,                 monterey:       "ecd6788e1602222b8965b71752d33e88b769fdc3dc0e56445c1a13f896642fdb"
    sha256 cellar: :any,                 big_sur:        "bde2715f2da99d1471f168b9e84371778d842f44030bf816648e92a0f3670716"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd7a74daf88f53d999f26306b8e19c07baf35aafd062aafdba42cf60fca75f38"
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
