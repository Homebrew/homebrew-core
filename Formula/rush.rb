class Rush < Formula
  desc "GNU's Restricted User SHell"
  homepage "https://www.gnu.org/software/rush/"
  url "https://ftp.gnu.org/gnu/rush/rush-2.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/rush/rush-2.1.tar.xz"
  sha256 "c2ff487d44ce3d14854d0269eb0aa4c0f98bcca35390fad5ea52da75d9e4abdf"

  bottle do
    sha256 "07ea3d94a8d34880b65ef978c5619e7bee5c67568d14a2afa7b3818541fe955d" => :mojave
    sha256 "421c4ff7a56f4d434ce69551fcdbfc9ec39bec8e472b4d64923be0a93adc6405" => :high_sierra
    sha256 "6147781c7c30c744d3e3aa69b55e72bb27a320aec6bf6e8d4a8360d5982aad20" => :sierra
    sha256 "a33fca1d7ccc86d125771c7f4e983244abe182d3a3731faa86fa12f21f7ab18d" => :el_capitan
    sha256 "5fcd6654497adb320a87fcf9b2b67361f157449f029a918148d90f60089920a1" => :yosemite
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
