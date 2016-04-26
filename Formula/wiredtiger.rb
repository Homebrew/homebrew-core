class Wiredtiger < Formula
  desc "high performance NoSQL extensible platform for data management"
  homepage "http://www.wiredtiger.com"
  url "https://github.com/wiredtiger/wiredtiger/releases/download/2.8.0/wiredtiger-2.8.0.tar.bz2"
  sha256 "593e4858a21465db6f8360cc6281489f8a114fa301bd2753c0bde9a86ef107e2"

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
