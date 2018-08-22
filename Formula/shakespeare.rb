class Shakespeare < Formula
  desc "Write programs in Shakespearean English"
  homepage "https://shakespearelang.sourceforge.io/"
  url "https://shakespearelang.sourceforge.io/download/spl-1.2.1.tar.gz"
  sha256 "1206ef0a2c853b8b40ca0c682bc9d9e0a157cc91a7bf4e28f19ccd003674b7d3"

  bottle do
    cellar :any
    rebuild 1
    sha256 "657bf548e23dd5564a32e1b86f983f1899e24966728e8e94dfdb981d35e60a45" => :mojave
    sha256 "7320be8a139934d9a80543a8017de6500f02971374a36038592ad122d76f85cf" => :high_sierra
    sha256 "6a8e746959adcbd5629bd6ec74fcc3854fa7355d098c14a640a6df23358ce335" => :sierra
    sha256 "86547f1b0967f8399f00b7120a251a126e66dfe9c52a4fb9b3d17331e2381895" => :el_capitan
    sha256 "1e35a35e7ca7eef401a76360320389fe23e2cea6db8bf9f2d266732c742ad8d5" => :yosemite
  end

  depends_on "flex" if MacOS.version >= :mountain_lion

  def install
    system "make", "install"
    bin.install "spl/bin/spl2c"
    include.install "spl/include/spl.h"
    lib.install "spl/lib/libspl.a"
  end
end
