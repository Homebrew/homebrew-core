class UBootTools < Formula
  desc "Universal boot loader"
  homepage "https://u-boot-project.org/"
  url "https://git.u-boot-project.org/u-boot/u-boot/-/releases/v2026.10/downloads/u-boot-2026.10.tar.bz2"
  sha256 "3f856da3cbbc93af51ff95fde18588a348b4a26723b01d9841e999d988481015"
  license all_of: ["GPL-2.0-only", "GPL-2.0-or-later", "BSD-3-Clause"]
  head "https://git.u-boot-project.org/u-boot/u-boot.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "44227749415024779958ece965c1f4d57002a27fe4c13eebfb495173ee84b76c"
    sha256 cellar: :any, arm64_tahoe:       "43425048d4b74664ee9f14a37383edbe1b38fd57747246e4a81deb074c133899"
    sha256 cellar: :any, arm64_sequoia:     "200480d90561d05d5879efb4c30c3157b7d18a232c2fa2bec85c2d932c61f0e6"
    sha256 cellar: :any, arm64_linux:       "454681adb5858f6f09063bf4af640c1976267c9c8b8e6d0a6c3dd1537fd6ba09"
    sha256 cellar: :any, x86_64_linux:      "04525b2ec07704fcde97bd10861e2f38e57e17b5c74b02743eeed53de33cfb85"
  end

  depends_on "coreutils" => :build # Makefile needs $(gdate)
  depends_on "openssl@3" # https://lists.u-boot-project.org/pipermail/u-boot/2026-April/616722.html

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  on_macos do
    depends_on "make" => :build
  end

  def install
    # Disable mkeficapsule
    inreplace "configs/tools-only_defconfig", "CONFIG_TOOLS_MKEFICAPSULE=y", "CONFIG_TOOLS_MKEFICAPSULE=n"

    system "gmake", "tools-only_defconfig"
    system "gmake", "tools-only", "NO_SDL=1"
    bin.install "tools/mkimage", "tools/dumpimage", "tools/mkenvimage"
    man1.install "doc/mkimage.1", "doc/dumpimage.1"
  end

  test do
    system bin/"mkimage", "-V"
    system bin/"dumpimage", "-V"
    system bin/"mkenvimage", "-V"
  end
end
