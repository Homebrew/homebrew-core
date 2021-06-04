class Zebra < Formula
  desc "Information management system"
  homepage "https://www.indexdata.com/resources/software/zebra/"
  url "http://ftp.indexdata.dk/pub/zebra/idzebra-2.2.2.tar.gz"
  sha256 "513c2bf272e12745d4a7b58599ded0bc1292a84e9dc420a32eb53b6601ae0000"
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url :homepage
    regex(%r{>Latest:</strong>.*?v?(\d+(?:\.\d+)+)<}i)
  end

  bottle do
    sha256 arm64_big_sur: "f307cea56094567e0eb6b1b9e1714c1793a00c91f4c6dbc6a05ad4b3c6fe599b"
    sha256 big_sur:       "48dd4bd61246cd8bcf78a81ea74cd555e042b68e0babf91ab2179a27a9a952c1"
    sha256 catalina:      "858db9d3aed2caa1ba44b8b4c642b56eed31d01f46d68a83a96e5460e695d320"
    sha256 mojave:        "20d87fb79630c0fa3416762a25e6495e307b19bf97eb17009fb8e76f5637ed69"
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
