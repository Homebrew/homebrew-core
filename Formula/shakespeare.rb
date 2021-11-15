class Shakespeare < Formula
  desc "Write programs in Shakespearean English"
  homepage "https://shakespearelang.sourceforge.io/"
  url "https://shakespearelang.sourceforge.io/download/spl-1.2.1.tar.gz"
  sha256 "1206ef0a2c853b8b40ca0c682bc9d9e0a157cc91a7bf4e28f19ccd003674b7d3"

  livecheck do
    url :homepage
    regex(/href=.*?spl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_monterey: "3ab0d3696105477919b381f0542705c43de2a242d6e57fdb3973a51963947ec3"
    sha256 cellar: :any, arm64_big_sur:  "60ae733b2e127fb14ce46ba46451ee2879f36e01154ab1d01ebd3347c7c18932"
    sha256 cellar: :any, monterey:       "d91fefd00f17aa0b7ec2229f511c0b1da4296632a35f3ebe956e8bedd2097447"
    sha256 cellar: :any, big_sur:        "31f4cbe6ba72079d2caf3822fec8804478c4ddf2bc5c45c8c816aed8eb5950e1"
    sha256 cellar: :any, catalina:       "189fbdefeea765fcb5b9b33cc1bde987fe57376b3aff1a0eada8faaec27a84aa"
    sha256 cellar: :any, mojave:         "657bf548e23dd5564a32e1b86f983f1899e24966728e8e94dfdb981d35e60a45"
    sha256 cellar: :any, high_sierra:    "7320be8a139934d9a80543a8017de6500f02971374a36038592ad122d76f85cf"
    sha256 cellar: :any, sierra:         "6a8e746959adcbd5629bd6ec74fcc3854fa7355d098c14a640a6df23358ce335"
    sha256 cellar: :any, el_capitan:     "86547f1b0967f8399f00b7120a251a126e66dfe9c52a4fb9b3d17331e2381895"
    sha256 cellar: :any, yosemite:       "1e35a35e7ca7eef401a76360320389fe23e2cea6db8bf9f2d266732c742ad8d5"
  end

  depends_on "flex"

  def install
    system "make", "install"
    bin.install "spl/bin/spl2c"
    include.install "spl/include/spl.h"
    lib.install "spl/lib/libspl.a"
  end
end
