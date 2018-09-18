class RiemannClient < Formula
  desc "C client library for the Riemann monitoring system"
  homepage "https://github.com/algernon/riemann-c-client"
  url "https://github.com/algernon/riemann-c-client/archive/riemann-c-client-1.10.3.tar.gz"
  sha256 "dc00d817d3f6fe214d21365d2b236b73d67fb317ea96c069222c11384d8b2508"
  head "https://github.com/algernon/riemann-c-client.git"

  bottle do
    cellar :any
    sha256 "8e9ce201ce8a1fe8d0de5a8fced449a848dcaf4e4b788bc3564df93bb120952d" => :mojave
    sha256 "bd861b2487f0e6f461bdcbac169cff5b8cbb0b86c845e654f8b0633a2b900984" => :high_sierra
    sha256 "991a572a714d96dc112f811a42659ee95017d3eb4a6d2c500ad67cb3a560c3f4" => :sierra
    sha256 "de08d8c372577a70a1789940c7253e3c3c930ce39aea7756bb235129de8c3e0f" => :el_capitan
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
