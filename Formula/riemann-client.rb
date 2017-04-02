class RiemannClient < Formula
  desc "C client library for the Riemann monitoring system"
  homepage "https://github.com/algernon/riemann-c-client"
  url "https://github.com/algernon/riemann-c-client/archive/riemann-c-client-1.9.1.tar.gz"
  sha256 "6c8279362384e0ee01cb84a12f645bf7229c7d61f565158fe4ecc82c36ce8dc0"
  head "https://github.com/algernon/riemann-c-client.git"

  bottle do
    cellar :any
    sha256 "9856af75fe69543e8e364c86a2be2ebd044e9b3de30c32e0fb7d6274199a0b5b" => :sierra
    sha256 "062a6545b63ecc33a9331509630443d77904132297c8beae3642aba6d2ba1b87" => :el_capitan
    sha256 "5e17f7589983a2f2e6e58516f7b6151032744d423b222502a23e572e6566b0f1" => :yosemite
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
