class Xapian < Formula
  desc "C++ search engine library"
  homepage "https://xapian.org/"
  url "https://oligarchy.co.uk/xapian/1.4.11/xapian-core-1.4.11.tar.xz"
  mirror "https://fossies.org/linux/www/xapian-core-1.4.11.tar.xz"
  sha256 "9f16b2f3e2351a24034d7636f73566ab74c3f0729e9e0492934e956b25c5bc07"

  bottle do
    cellar :any
    sha256 "f802e17710ae6f4b01e2a85103537a5b39915984700207a42dd1ab1da43dfaf9" => :mojave
    sha256 "df8a268b9016f9b8cc60290bd28aa8281bb8739c0b13957425d48f22d24cb4da" => :high_sierra
    sha256 "a1a49718ad026797c150e012c712ad69a9d6e5a278a4750d0bddd1656a41014a" => :sierra
  end

  skip_clean :la

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"xapian-config", "--libs"
  end
end
