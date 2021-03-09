class Wiredtiger < Formula
  desc "High performance NoSQL extensible platform for data management"
  homepage "http://www.wiredtiger.com"
  url "https://github.com/wiredtiger/wiredtiger/releases/download/3.2.0/wiredtiger-3.2.0.tar.bz2"
  sha256 "c812d34ac542fdd2f5dc16e2f47ebc1eba09487f45e34fbae5a052a668931968"

  livecheck do
    url "https://github.com/wiredtiger/wiredtiger.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, big_sur:     "24076b53baf3e50cb523ab04d5caad5d9c155b834bc951e9a9576af3a0789c7f"
    sha256 cellar: :any, catalina:    "9b0799ed632b6b053c1f208a3a91c4eb97bfab817542267b32cc42ad0da11da0"
    sha256 cellar: :any, mojave:      "6346862c90443a6fc72cb214e2b657fcd69980dcd3d622b9017c150b955d4891"
    sha256 cellar: :any, high_sierra: "c831e84a17cc41fbb4a4571aad5460fc989fd865c0e770b9bf65399bfeb46f4b"
    sha256 cellar: :any, sierra:      "27744de01928c6f529028861fb5b443885f8fc320deb0c61ac2a7bd754d44d7e"
  end

  depends_on "snappy"

  uses_from_macos "zlib"

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
