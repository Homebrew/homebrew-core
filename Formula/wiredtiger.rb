class Wiredtiger < Formula
  desc "High performance NoSQL extensible platform for data management"
  homepage "http://www.wiredtiger.com"
  url "https://github.com/wiredtiger/wiredtiger/releases/download/2.9.1/wiredtiger-2.9.1.tar.bz2"
  sha256 "2995acab3422f1667b50e487106c6c88b8666d3cf239d8ecffa2dbffb17dfdcf"
  revision 2

  bottle do
    cellar :any
    sha256 "3b9f4b876961b205cec7edcd6704756d0ece6c01b3c963f32d8ca72ace02321a" => :sierra
    sha256 "2b33cdb3259147a246938f4e3bc4b151c82d925b33530486b50fbc946463d4a5" => :el_capitan
    sha256 "70db1152f21fae652582d93e4a14f48c9beb580bc92053a22aa13d9ae8a425fb" => :yosemite
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
