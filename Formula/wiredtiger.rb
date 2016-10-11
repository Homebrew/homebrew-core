class Wiredtiger < Formula
  desc "high performance NoSQL extensible platform for data management"
  homepage "http://www.wiredtiger.com"
  url "https://github.com/wiredtiger/wiredtiger/releases/download/2.8.0/wiredtiger-2.8.0.tar.bz2"
  sha256 "593e4858a21465db6f8360cc6281489f8a114fa301bd2753c0bde9a86ef107e2"

  bottle do
    cellar :any
    sha256 "f4c44969ac65d514659f4422b1ab119f09e7daa8530b840fd08551e0e6b47a80" => :sierra
    sha256 "a5c3fd2444a26a657a4e8a1e84a9f8fbbe0388601b9b855b8b0b2c3075e1d1fd" => :el_capitan
    sha256 "19ea6e84544c58a232b2a1231f038fd4a09e516e29fd761be815bdd0a3f06c30" => :yosemite
    sha256 "e12d809b163ef92fbac6ec22f3083675716b3f83c55dc35d1b7ca902bb723fd7" => :mavericks
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
