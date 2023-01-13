class Zebra < Formula
  desc "Information management system"
  homepage "https://www.indexdata.com/resources/software/zebra/"
  url "https://ftp.indexdata.com/pub/zebra/idzebra-2.2.7.tar.gz"
  sha256 "b465ffeb060f507316e6cfc20ebd46022472076d0d4e96ef7dab63e798066420"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://ftp.indexdata.com/pub/zebra/"
    regex(/href=.*?idzebra[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "bc47098d8ebe543a011fcb4a34042d69140954d9ad4129ec6f15ce7c44a57c84"
    sha256 arm64_monterey: "33a48c82e2d3d34dd168ac5c5f30d7eeb68706ebfe4fca5f4f743e8c8f8c7d7d"
    sha256 arm64_big_sur:  "02a6d5a901c190bd1130077f3f6f46845f9973b89e387ab2a6f445c3d5e52ebe"
    sha256 ventura:        "29e8244bb036655f5972c728f4181fa9fecdda2660e5a18a706b39170a9f4fbb"
    sha256 monterey:       "e8053445a0d04c64f9927742b8bb021ae82c77aaea9745547d88562c1cc45c2e"
    sha256 big_sur:        "8fef9cc6a75a9e05ad9684f6e162d7f7e99df5b7ff7df0f42f9378fd4fd44830"
    sha256 x86_64_linux:   "53385db244b4140a36f1d31aaffee3ac9c110d456330e255bbd97d1a327edc42"
  end

  depends_on "icu4c"
  depends_on "yaz"

  uses_from_macos "bzip2"
  uses_from_macos "expat"
  uses_from_macos "libxcrypt"
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "zlib"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-mod-text",
                          "--enable-mod-grs-regx",
                          "--enable-mod-grs-marc",
                          "--enable-mod-grs-xml",
                          "--enable-mod-dom",
                          "--enable-mod-alvis",
                          "--enable-mod-safari"
    system "make", "install"
  end

  test do
    cd share/"idzebra-2.0-examples/oai-pmh/" do
      system bin/"zebraidx-2.0", "-c", "conf/zebra.cfg", "init"
      system bin/"zebraidx-2.0", "-c", "conf/zebra.cfg", "commit"
    end
  end
end
