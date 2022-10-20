class UBootTools < Formula
  desc "Universal boot loader"
  homepage "https://www.denx.de/wiki/U-Boot/"
  url "https://ftp.denx.de/pub/u-boot/u-boot-2022.10.tar.bz2"
  sha256 "50b4482a505bc281ba8470c399a3c26e145e29b23500bc35c50debd7fa46bdf8"
  license all_of: ["GPL-2.0-only", "GPL-2.0-or-later", "BSD-3-Clause"]

  livecheck do
    url "https://ftp.denx.de/pub/u-boot/"
    regex(/href=.*?u-boot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a079a3ed32907b5ff4761b6f2e42c18ea5cd09bf1cec1a9b6c42d15d412df31f"
    sha256 cellar: :any,                 arm64_big_sur:  "64206ca55f97af61ab1de8d63ad410c237e1bc408539d9d490bd3e882fb40bb7"
    sha256 cellar: :any,                 monterey:       "dae33b7bf6752a698c25669a65ac4dd8283a16dab1077a8ac28a868a7f4900f8"
    sha256 cellar: :any,                 big_sur:        "0f19798bbd25e67ce2eeedfafab61e550d2a33b3ac589d868427076513f86052"
    sha256 cellar: :any,                 catalina:       "2a66e97b6ebf39dd18715ae9e062d836fde211e00f1b6db037b7ce9e02c3a804"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db63534ce320b568c19f4ccafe7972ef4f85160add5b3e6d6487e1016ee38575"
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
