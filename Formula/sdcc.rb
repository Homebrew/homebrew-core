class Sdcc < Formula
  desc "ANSI C compiler for Intel 8051, Maxim 80DS390, and Zilog Z80"
  homepage "https://sdcc.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/sdcc/sdcc/3.8.0/sdcc-src-3.8.0.tar.bz2"
  sha256 "b331668deb7bd832efd112052e5b0ed2313db641a922bd39280ba6d47adbbb21"
  head "http://svn.code.sf.net/p/sdcc/code/trunk/sdcc"

  bottle do
    sha256 "2efd0fd48bf2e2355b43955b64367169256b462cb5195fd2268b424c03c043de" => :mojave
    sha256 "b80bbd646be2fe3f66a46e616537b385211b03b3f22b16fdf85ab92d64dba88e" => :high_sierra
    sha256 "c9b31ad24400562817d0ec03fd88051e62d1ba434f0f4750388cd1143afb1547" => :sierra
    sha256 "560804d50e214be12ce4417fd5edc5137d2d987c3d1617d4659284d8b614a1bf" => :el_capitan
  end

  depends_on "boost"
  depends_on "gputils"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "all"
    system "make", "install"
    rm Dir["#{bin}/*.el"]
  end

  test do
    system "#{bin}/sdcc", "-v"
  end
end
