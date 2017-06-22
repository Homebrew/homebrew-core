class RiemannClient < Formula
  desc "C client library for the Riemann monitoring system"
  homepage "https://github.com/algernon/riemann-c-client"
  url "https://github.com/algernon/riemann-c-client/archive/riemann-c-client-1.10.1.tar.gz"
  sha256 "93ccef65536e0cd3a1b3301847773f50fc298a455b4294e465d73fa7daf7c8bf"
  head "https://github.com/algernon/riemann-c-client.git"

  bottle do
    cellar :any
    sha256 "c9450f504bbf36468970200f717672264059da7ddcfb1aa3adbcb00bb1ebf16f" => :sierra
    sha256 "44a0af4942453419f6ca5c86ce24ed117069102987609c3b0381ff2139786f99" => :el_capitan
    sha256 "0488fdbe4fc70847b15f4c2959f27ab0acf14d3ce9735fd770d43607d4efe850" => :yosemite
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
