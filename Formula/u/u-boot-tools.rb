class UBootTools < Formula
  desc "Universal boot loader"
  homepage "https://www.denx.de/wiki/U-Boot/"
  url "https://ftp.denx.de/pub/u-boot/u-boot-2025.07.tar.bz2"
  sha256 "0f933f6c5a426895bf306e93e6ac53c60870e4b54cda56d95211bec99e63bec7"
  license all_of: ["GPL-2.0-only", "GPL-2.0-or-later", "BSD-3-Clause"]

  livecheck do
    url "https://ftp.denx.de/pub/u-boot/"
    regex(/href=.*?u-boot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fcb8aad340c73aa361e9d106b067e527477e4b2abfa02ffc723680ffdc3e2295"
    sha256 cellar: :any,                 arm64_sonoma:  "c1284554801826adb6936cb4fd663e8af2730502cb15bef643558a082d2542e6"
    sha256 cellar: :any,                 arm64_ventura: "bad39af7c2f5bc98496e74d6b4ba796c0e4a86af30831ec6986e1a6563844226"
    sha256 cellar: :any,                 sonoma:        "66f877615b6694555180ce23779f02f020d7e591464ffada084d98dbdc71d539"
    sha256 cellar: :any,                 ventura:       "1f1acb6c6f0e80199feb0f45788d059e7bc94bcd023ef1ffafbbd6b881ab5bc0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee9f4c8cb3b79107c313a443cb03991566704fcb8bd7cb6f155e0e724ad4bc37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01d68fb58896a883733c717350e95bb7057d20d79a13b72cdb2f03515a944de8"
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
