class RiemannClient < Formula
  desc "C client library for the Riemann monitoring system"
  homepage "https://github.com/algernon/riemann-c-client"
  url "https://github.com/algernon/riemann-c-client/archive/riemann-c-client-1.10.3.tar.gz"
  sha256 "dc00d817d3f6fe214d21365d2b236b73d67fb317ea96c069222c11384d8b2508"
  head "https://github.com/algernon/riemann-c-client.git"

  bottle do
    cellar :any
    sha256 "ba9cdc31d7fe2916f8e3372991b6220ff314cea3b3ec12a5a340b0ad248b3fcf" => :high_sierra
    sha256 "c57193eb61597b2fc23bdba949187fcdb9501104be779f9478c6f59d58a0916a" => :sierra
    sha256 "061be81a19aa935e9bc24c3fcd54f113de05f0e70c7e43bc6deb62180cacaf15" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libtool" => :build

  depends_on "json-c"
  depends_on "protobuf-c"

  def install
    system "autoreconf", "-i"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/riemann-client", "send", "-h"
  end
end
