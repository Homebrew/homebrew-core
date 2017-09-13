class RiemannClient < Formula
  desc "C client library for the Riemann monitoring system"
  homepage "https://github.com/algernon/riemann-c-client"
  url "https://github.com/algernon/riemann-c-client/archive/riemann-c-client-1.10.2.tar.gz"
  sha256 "d69d06a3bde6c192324489b05503b5584c7c7969f2540deeb269c370fdc75cda"
  head "https://github.com/algernon/riemann-c-client.git"

  bottle do
    cellar :any
    sha256 "cf5f268e934bbf16faf8fcb9dd042698daa1199d6f465b70d700482ee1c03d52" => :sierra
    sha256 "5ea7d37d883608833a4f75ff024850a4754a8ecacc8246f3f689eb2f25dff564" => :el_capitan
    sha256 "58c9d2d70c5523aa89060ee54d4d85de87c5c7aa6a8ae0b876f9ddefa7ceabf6" => :yosemite
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
