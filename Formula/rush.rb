class Rush < Formula
  desc "GNU's Restricted User SHell"
  homepage "https://www.gnu.org/software/rush/"
  url "https://ftp.gnu.org/gnu/rush/rush-1.8.tar.gz"
  mirror "https://ftpmirror.gnu.org/rush/rush-1.8.tar.gz"
  sha256 "7f321e5556435b12638982c8d94c587982122f28c220f8bc679d7817035aadef"

  bottle do
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
