class Wiredtiger < Formula
  desc "High performance NoSQL extensible platform for data management"
  homepage "http://www.wiredtiger.com"
  url "https://github.com/wiredtiger/wiredtiger/releases/download/3.0.0/wiredtiger-3.0.0.tar.bz2"
  sha256 "a6662ecedc824ed61895c34821a1f9adbf5d3cf04630fa3d3881cb2b9573a304"

  bottle do
    cellar :any
    sha256 "ebdd725345824110245805eaa5352ba5e02bddee768a7260d2de6d631cd27a67" => :high_sierra
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
