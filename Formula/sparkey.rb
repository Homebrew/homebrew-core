class Sparkey < Formula
  desc "Constant key-value store, best for frequent read/infrequent write uses"
  homepage "https://github.com/spotify/sparkey/"
  url "https://github.com/spotify/sparkey/archive/sparkey-1.0.0.tar.gz"
  sha256 "d607fb816d71d97badce6301dd56e2538ef2badb6530c0a564b1092788f8f774"

  bottle do
    cellar :any
    sha256 "c2c88d318d112376f08a81dd3c38746b0843e1e0fe5c03d1545f7606db2561ba" => :mojave
    sha256 "619dd968f275dca8239cf39c7d4f6c571ca883190e84bf2246a45d4e5c944a81" => :high_sierra
    sha256 "e19c744556628667d81cfc40c792224b424f545fac1abfd76189d3f675478801" => :sierra
    sha256 "fb3c2f20c08d28a563a9d8a0849e0f2492c3a007345c09c81710060d07796054" => :el_capitan
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
