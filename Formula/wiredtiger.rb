class Wiredtiger < Formula
  desc "High performance NoSQL extensible platform for data management"
  homepage "http://www.wiredtiger.com"
  url "https://github.com/wiredtiger/wiredtiger/releases/download/2.9.3/wiredtiger-2.9.3.tar.bz2"
  sha256 "2502a90d6b3d3cae0b1bf221cbfe13999d3bcb7f8bb9fa795ad870be4fc0e1e7"

  bottle do
    cellar :any
    sha256 "32a967857da0c3ba8124fcd0ab959da98cc0aa33ac4d7c506b29d5b6409fc0d7" => :sierra
    sha256 "ea725e44e979e227d7e0a911354be71e0b0c404d1b2d360bf28d164dd1db1d36" => :el_capitan
    sha256 "4f13ca58bb58e338611b247a6a143f29eb1b720b0c3da144dcff57ebb31a3274" => :yosemite
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
