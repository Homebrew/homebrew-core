class Sdcc < Formula
  desc "ANSI C compiler for Intel 8051, Maxim 80DS390, and Zilog Z80"
  homepage "http://sdcc.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/sdcc/sdcc/3.6.0/sdcc-src-3.6.0.tar.bz2"
  sha256 "e85dceb11e01ffefb545ec389da91265130c91953589392dddd2e5ec0b7ca374"

  head "https://sdcc.svn.sourceforge.net/svnroot/sdcc/trunk/sdcc/"

  bottle do
    sha256 "b5b8e259cf24cf913201fa4db9da37a3a7a7464dd351e9aa2e3ce5deb2221db2" => :sierra
    sha256 "18750431c03b67a6df0e81dc881d4f1fe041fd228b449dd4de575fee1cac4d12" => :el_capitan
    sha256 "85594a6e63c1565877a36d415105a44401f3e77c5fbf04cbfa4a8613c96b24f7" => :yosemite
    sha256 "873b8a76f4d16379f5a57516306924a39053c3ddffb75b9bf7796c2bf0b4078f" => :mavericks
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
