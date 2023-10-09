class UBootTools < Formula
  desc "Universal boot loader"
  homepage "https://www.denx.de/wiki/U-Boot/"
  url "https://ftp.denx.de/pub/u-boot/u-boot-2023.10.tar.bz2"
  sha256 "e00e6c6f014e046101739d08d06f328811cebcf5ae101348f409cbbd55ce6900"
  license all_of: ["GPL-2.0-only", "GPL-2.0-or-later", "BSD-3-Clause"]

  livecheck do
    url "https://ftp.denx.de/pub/u-boot/"
    regex(/href=.*?u-boot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1ef8aee6c5bc9b61ff1734acff9a3916cd089aae1d78943ee1f60904982ec8e4"
    sha256 cellar: :any,                 arm64_ventura:  "dd8ca73134a14fbe5e4663e791e87f219814a246e4a575e08cbbe9156efd57cd"
    sha256 cellar: :any,                 arm64_monterey: "a21d822f8417143dbecbf168e16afa6adb142e1db96656dbe3a7c40e01f0d7e3"
    sha256 cellar: :any,                 sonoma:         "99f6d5247ef02ab60a72728712abef0613ff3e8940ce61cf3364a1ed55c5befa"
    sha256 cellar: :any,                 ventura:        "dcddb25e8074bb66e777ab21504ed2b8f584a1b065f265074e78206cfe103fe1"
    sha256 cellar: :any,                 monterey:       "186df11211dff66e6fab30eb4180dfd227f7fb0445b5cfeb43566cadc9c7648a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd4297c1853dbb279ceba3fcc4109f523fe1ca04c5c4960026d4a2abee41f085"
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
