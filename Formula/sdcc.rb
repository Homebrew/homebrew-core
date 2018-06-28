class Sdcc < Formula
  desc "ANSI C compiler for Intel 8051, Maxim 80DS390, and Zilog Z80"
  homepage "https://sdcc.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/sdcc/sdcc/3.7.0/sdcc-src-3.7.0.tar.bz2"
  sha256 "854d47094698b06142df3d5fc646bb540d497ab4073ad2f051b8ec2141df948e"
  head "https://svn.code.sf.net/p/sdcc/code/trunk/sdcc"

  bottle do
    sha256 "b80bbd646be2fe3f66a46e616537b385211b03b3f22b16fdf85ab92d64dba88e" => :high_sierra
    sha256 "c9b31ad24400562817d0ec03fd88051e62d1ba434f0f4750388cd1143afb1547" => :sierra
    sha256 "560804d50e214be12ce4417fd5edc5137d2d987c3d1617d4659284d8b614a1bf" => :el_capitan
  end

  option "with-avr-port", "Enables the AVR port (UNSUPPORTED, MAY FAIL)"
  option "with-xa51-port", "Enables the xa51 port (UNSUPPORTED, MAY FAIL)"

  deprecated_option "enable-avr-port" => "with-avr-port"
  deprecated_option "enable-xa51-port" => "with-xa51-port"

  depends_on "gputils"
  depends_on "boost"

  def install
    args = %W[--prefix=#{prefix}]
    args << "--enable-avr-port" if build.with? "avr-port"
    args << "--enable-xa51-port" if build.with? "xa51-port"

    system "./configure", *args
    system "make", "all"
    system "make", "install"
    rm Dir["#{bin}/*.el"]
  end

  test do
    system "#{bin}/sdcc", "-v"
  end
end
