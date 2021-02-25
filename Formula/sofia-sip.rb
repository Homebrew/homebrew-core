class SofiaSip < Formula
  desc "SIP User-Agent library"
  homepage "https://sofia-sip.sourceforge.io/"
  url "https://github.com/freeswitch/sofia-sip/archive/v1.13.3.tar.gz"
  sha256 "6f9cc7ed674e2214809e390728da0df646f94e5b991cff9f393217176de9d7e4"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "e7b5462066dbb0bce9d0e6d16e709fc3adaf99f3624d136d5c929a8d6d5b68ba"
    sha256 cellar: :any, big_sur:       "4f581160ed9d9e1c478aca087b53483b493fd747afd480ad18fa2bc6ce5931b2"
    sha256 cellar: :any, catalina:      "ab14de67ceb92a79d8095b94d3e76680765185088773fe4c5b014574ef32a892"
    sha256 cellar: :any, mojave:        "5f9a402b196aa592405fb10ddca2bd8f3736d62cfd8f2709d52fb18d9402af8f"
    sha256 cellar: :any, high_sierra:   "7729020836b875104c6044afd0a72cf8755619978216430d89a585cf9783c8b0"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "openssl@1.1"

  def install
    system "./bootstrap.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/localinfo"
    system "#{bin}/sip-date"
  end
end
