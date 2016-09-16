class Sdcc < Formula
  desc "ANSI C compiler for Intel 8051, Maxim 80DS390, and Zilog Z80"
  homepage "http://sdcc.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/sdcc/sdcc/3.6.0/sdcc-src-3.6.0.tar.bz2"
  sha256 "e85dceb11e01ffefb545ec389da91265130c91953589392dddd2e5ec0b7ca374"

  head "https://sdcc.svn.sourceforge.net/svnroot/sdcc/trunk/sdcc/"

  bottle do
    revision 1
    sha256 "d46fdad8f291ea90162e7218ec3d43468de8b85680da5f1088617be8521005f5" => :el_capitan
    sha256 "b5cd6950c3dd7b2d7399e0a7eabdd02992a34b8ec0c1c9fc9e46ddc7f561fce6" => :yosemite
    sha256 "73aecffe0f2ec715f532c09ef0f95d3a045582cc65b5e10c48208eac5bfe655e" => :mavericks
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
