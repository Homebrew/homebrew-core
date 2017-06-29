class Wiredtiger < Formula
  desc "High performance NoSQL extensible platform for data management"
  homepage "http://www.wiredtiger.com"
  url "https://github.com/wiredtiger/wiredtiger/releases/download/2.9.1/wiredtiger-2.9.1.tar.bz2"
  sha256 "2995acab3422f1667b50e487106c6c88b8666d3cf239d8ecffa2dbffb17dfdcf"
  revision 1

  bottle do
    cellar :any
    sha256 "da99b2e657972518071a86f4633b54f5e74ed6e34b8ad047e0c2f6abbdb8f7d1" => :sierra
    sha256 "a75213abe8e436012bbf2a3830fdd941dc2987c1259a6c9ea1813392e8b8ffdf" => :el_capitan
    sha256 "9d0ddaaf2a8c765723f820d676d54340e1ea90566ca4e74a1537ecc8216578d5" => :yosemite
  end

  depends_on "snappy"

  def install
    system "./configure", "--with-builtins=snappy,zlib",
                          "--with-python",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/wt", "create", "table:test"
    system "#{bin}/wt", "drop", "table:test"
  end
end
