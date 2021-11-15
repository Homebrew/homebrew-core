class UBootTools < Formula
  desc "Universal boot loader"
  homepage "https://www.denx.de/wiki/U-Boot/"
  url "https://ftp.denx.de/pub/u-boot/u-boot-2021.10.tar.bz2"
  sha256 "cde723e19262e646f2670d25e5ec4b1b368490de950d4e26275a988c36df0bd4"
  license all_of: ["GPL-2.0-only", "GPL-2.0-or-later", "BSD-3-Clause"]

  livecheck do
    url "https://ftp.denx.de/pub/u-boot/"
    regex(/href=.*?u-boot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "46d10310bde67e69ca0ca324728cc6c0e95bc3ff6c3f24644e6c25ec2d7f3948"
    sha256 cellar: :any,                 arm64_big_sur:  "7ed89bdfdf7c129de811e6bf1ee2b306a20c0a922e9a998011c652e81b9ba099"
    sha256 cellar: :any,                 monterey:       "ec5c40f352a1fb603c694c3c94046316b7fa87d934fde9ce3110bcdc75a6d5e8"
    sha256 cellar: :any,                 big_sur:        "4dfb85faaad3da512619216a0159864f21acd8d9c41e70461ea97a680e296c76"
    sha256 cellar: :any,                 catalina:       "e74626de6dda88a5dde743eeeec5c807169cda61b5a67462ae5d673e1c4edaaa"
    sha256 cellar: :any,                 mojave:         "f67521ce162fdcb22ce0c5d5236376260f63f9a32d5cb0a5b3b308faec3d3764"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1a01204bd4e86fec942c4890eda4cd74549e28059119737132ee3c7d40dfc19"
  end

  depends_on "coreutils" => :build # Makefile needs $(gdate)
  depends_on "openssl@1.1"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    # Replace keyword not present in make 3.81
    inreplace "Makefile", "undefine MK_ARCH", "unexport MK_ARCH"

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
