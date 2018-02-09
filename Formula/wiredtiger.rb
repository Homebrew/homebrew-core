class Wiredtiger < Formula
  desc "High performance NoSQL extensible platform for data management"
  homepage "http://www.wiredtiger.com"
  url "https://github.com/wiredtiger/wiredtiger/releases/download/3.0.0/wiredtiger-3.0.0.tar.bz2"
  sha256 "a6662ecedc824ed61895c34821a1f9adbf5d3cf04630fa3d3881cb2b9573a304"

  bottle do
    cellar :any
    sha256 "9b28c70a1c34b298767cfb0e39701639d268a29333cbff304621da049d03bcd4" => :high_sierra
    sha256 "54973355aa846d8ff623d96b7890ca24abab9c777e8378afc8df5eda2f7135ff" => :sierra
    sha256 "f515b54643c9a1282f5f317b925b67bcdd3e43436701b53cf760332a08b68ca1" => :el_capitan
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
