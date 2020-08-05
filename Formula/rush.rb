class Rush < Formula
  desc "GNU's Restricted User SHell"
  homepage "https://www.gnu.org/software/rush/"
  url "https://ftp.gnu.org/gnu/rush/rush-2.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/rush/rush-2.1.tar.xz"
  sha256 "c2ff487d44ce3d14854d0269eb0aa4c0f98bcca35390fad5ea52da75d9e4abdf"

  bottle do
    sha256 "a818df5c93d76a0a53c47108af3009a6d8265722d132204a636e29460693ac0d" => :catalina
    sha256 "5cdc9e464c7086e99e26063787dfefafd4805d90b0ea5aa40044b81f23d10db1" => :mojave
    sha256 "a76250fc5b34898050b9e18abd00dffbefd2c37dcd021b37d30bef75574abe49" => :high_sierra
    sha256 "55acb177bf3b6c2d041341b9a625ac10c6aba1237974febd66e40f1a7ec23319" => :sierra
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{sbin}/rush", "-h"
  end
end
