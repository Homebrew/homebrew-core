class Rush < Formula
  desc "GNU's Restricted User SHell"
  homepage "https://www.gnu.org/software/rush/"
  url "https://ftp.gnu.org/gnu/rush/rush-2.2.tar.xz"
  mirror "https://ftpmirror.gnu.org/rush/rush-2.2.tar.xz"
  sha256 "b1fb69dcd2b082cc5bca804307baeec4ed6da77f747df0066c7d1ad2c353797f"
  license "GPL-3.0"

  bottle do
    sha256 arm64_monterey: "445f930202419132422e29d8077a67883f57f84b79c655a867b53a9da1541011"
    sha256 arm64_big_sur:  "02bf135ba37d2a68adf4d089bd893f1e8c7b4892e61e78a0720f074fdb591adb"
    sha256 monterey:       "7b5c12cd913819383a2afb21272602fed6523bc97871bf469911d09f0fb12f69"
    sha256 big_sur:        "433fea9129d74f349d42ecb66d67d036ee8e9e397582d23f16ad4b209861a06a"
    sha256 catalina:       "9b152b080009d9b887921772631b786b2ddf5893dd2845f11355b637d397d027"
    sha256 x86_64_linux:   "07ff7b8fae886c1728cc2244296bbc583b802dce004ea17a5f34b6009b06ffd4"
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
