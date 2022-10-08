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
    sha256 cellar: :any,                 arm64_monterey: "6c3767e26ec0d6455e1ff73dbc4be110af93f705edf57370ea05c3b3ac07d524"
    sha256 cellar: :any,                 arm64_big_sur:  "d241fd0f84e4e7c351da99249290fa2c569b1f8a864e44accf6ceb8823ef7065"
    sha256 cellar: :any,                 monterey:       "f37e3945cbfc998b992d58ff24ba9d804c3fcf7fb9487b7ea4a541ebf00a1a49"
    sha256 cellar: :any,                 big_sur:        "81865f1b1670454c2b7d48a8b5776d375e3feabd9f2c2343ba780ae2818b1545"
    sha256 cellar: :any,                 catalina:       "ca5d9a0d173442a9e513036d2a424cf0f2a4bfd1bfa0f2bebe58429939921dae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b5f4f6b68eb747d764a5e51060705d2c27b16a45d83eea10f35a093b3cc1658"
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
