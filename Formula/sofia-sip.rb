class SofiaSip < Formula
  desc "SIP User-Agent library"
  homepage "https://sofia-sip.sourceforge.io/"
  url "https://github.com/freeswitch/sofia-sip/archive/v1.13.2.tar.gz"
  sha256 "b9eca9688ce4b28e062daf0933c3bf661fb607e7afafa71bda3e8f07eb88df44"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "4f581160ed9d9e1c478aca087b53483b493fd747afd480ad18fa2bc6ce5931b2" => :big_sur
    sha256 "e7b5462066dbb0bce9d0e6d16e709fc3adaf99f3624d136d5c929a8d6d5b68ba" => :arm64_big_sur
    sha256 "ab14de67ceb92a79d8095b94d3e76680765185088773fe4c5b014574ef32a892" => :catalina
    sha256 "5f9a402b196aa592405fb10ddca2bd8f3736d62cfd8f2709d52fb18d9402af8f" => :mojave
    sha256 "7729020836b875104c6044afd0a72cf8755619978216430d89a585cf9783c8b0" => :high_sierra
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
