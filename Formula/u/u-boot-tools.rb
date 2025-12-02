class UBootTools < Formula
  desc "Universal boot loader"
  homepage "https://www.denx.de/wiki/U-Boot/"
  url "https://ftp.denx.de/pub/u-boot/u-boot-2025.10.tar.bz2"
  sha256 "b4f032848e56cc8f213ad59f9132c084dbbb632bc29176d024e58220e0efdf4a"
  license all_of: ["GPL-2.0-only", "GPL-2.0-or-later", "BSD-3-Clause"]

  livecheck do
    url "https://ftp.denx.de/pub/u-boot/"
    regex(/href=.*?u-boot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "eae837cdcebd80c439d182556a223200722850c402c6646a5999a848f07b4805"
    sha256 cellar: :any,                 arm64_sequoia: "45d6adf6ae44e41ef0d82ae6280f84fd229b5488fc34d02a20ae657d8880b501"
    sha256 cellar: :any,                 arm64_sonoma:  "1fca5fdd813fffeddbcc88be551b6a262205968a04611c3ba2f234d5bfe5662e"
    sha256 cellar: :any,                 sonoma:        "3fe021a9ce76a2b2565e530e1fd5a5cc59ced4f36cf80ac03fc571e100caadf2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da73a2faec910b22297eb01f8013306d60f1ca186e6cf5274f1beb807acfbae7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52eec93eb9c5d038ff7405c35ce0cd8f5957c6662da009fa202df86d4da63246"
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
