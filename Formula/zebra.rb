class Zebra < Formula
  desc "Information management system"
  homepage "https://www.indexdata.com/resources/software/zebra/"
  url "http://ftp.indexdata.dk/pub/zebra/idzebra-2.2.2.tar.gz"
  sha256 "513c2bf272e12745d4a7b58599ded0bc1292a84e9dc420a32eb53b6601ae0000"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :homepage
    regex(%r{>Latest:</strong>.*?v?(\d+(?:\.\d+)+)<}i)
  end

  bottle do
    sha256 arm64_big_sur: "b30d43d96eaef2d04e95af46e70ef8b1baa66e094d601fdb64a0f8c8abaaf091"
    sha256 big_sur:       "92e6b6f82408307944dc5dd150eb34fbead3f53d56dc2443f3d2c77c7b79c5b6"
    sha256 catalina:      "eaf67815e4b8131f13b765cfc867a66ee9ac4d45daec07783901e1842c9b762b"
    sha256 mojave:        "54357482aefeac9d75bf849e7b102afea565e4eba42d1713a8c2388e3607b2a3"
  end

  depends_on "icu4c"
  depends_on "yaz"

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
