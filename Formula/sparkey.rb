class Sparkey < Formula
  desc "Constant key-value store, best for frequent read/infrequent write uses"
  homepage "https://github.com/spotify/sparkey/"
  url "https://github.com/spotify/sparkey/archive/sparkey-1.0.0.tar.gz"
  sha256 "d607fb816d71d97badce6301dd56e2538ef2badb6530c0a564b1092788f8f774"

  bottle do
    cellar :any
    sha256 "1b371fb46561f2639305eb65e7afac42b8b8d0ecd30b9958bf2cdd729e916e64" => :high_sierra
    sha256 "1e5641b08ac4e0d3e749a3b9c7d0b82a339eee1ea3db4fbeb00d41fe5fc9664e" => :sierra
    sha256 "df37f1f8f53f2292469e1af4d8246352cfb84544d2f496372d01d51df2d7113b" => :el_capitan
    sha256 "4e76ff0a0570384efeb61d43398f2118fa2b28e5b3270bf7803ca2ad0a515074" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "snappy"

  def install
    system "autoreconf", "--install"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/sparkey", "createlog", "-c", "snappy", "test.spl"
    system "echo foo.bar | #{bin}/sparkey appendlog -d . test.spl"
    system "#{bin}/sparkey", "writehash", "test.spl"
    system "#{bin}/sparkey get test.spi foo | grep ^bar$"
  end
end
