class RiemannClient < Formula
  desc "C client library for the Riemann monitoring system"
  homepage "https://github.com/algernon/riemann-c-client"
  url "https://github.com/algernon/riemann-c-client/archive/riemann-c-client-1.10.4.tar.gz"
  sha256 "334874f0b9a507a8abbc7138df719cba4f28f12c02c39d5e55090b8edb86f9d2"
  head "https://github.com/algernon/riemann-c-client.git"

  bottle do
    cellar :any
    sha256 "692dbcd6a5dbbbeb509d6022a18fcb7f20dd638722463e892359129bd55f10bf" => :mojave
    sha256 "be90a238e4e68d45b658c25ca96de21f9fab54e19832ae6dea06ec9c6fc5aa33" => :high_sierra
    sha256 "2052ba57754d3049747245a30caf32c81e5e7ec1b8f8de1790dde9c54f71548a" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

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
