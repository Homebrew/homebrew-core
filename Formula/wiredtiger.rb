class Wiredtiger < Formula
  desc "High performance NoSQL extensible platform for data management"
  homepage "http://www.wiredtiger.com"
  url "https://github.com/wiredtiger/wiredtiger/releases/download/3.2.1/wiredtiger-3.2.1.tar.bz2"
  sha256 "1a8b4fcd1abc22d8cbe483e1c33c0937a603d3d33ad24d0fca61233a5dc29592"

  bottle do
    cellar :any
    sha256 "6346862c90443a6fc72cb214e2b657fcd69980dcd3d622b9017c150b955d4891" => :mojave
    sha256 "c831e84a17cc41fbb4a4571aad5460fc989fd865c0e770b9bf65399bfeb46f4b" => :high_sierra
    sha256 "27744de01928c6f529028861fb5b443885f8fc320deb0c61ac2a7bd754d44d7e" => :sierra
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
