class Zebra < Formula
  desc "Information management system"
  homepage "https://www.indexdata.com/zebra"
  url "http://ftp.indexdata.dk/pub/zebra/idzebra-2.1.3.tar.gz"
  sha256 "5975c054a4cf50fb97d261b239f6f04f65dec7a2f72022b5abadea4e64405ee3"
  revision 1

  bottle do
    sha256 "6f7665efc555ed08e5d7b9dd0de741f4e014d26462b163adb29e606456803517" => :high_sierra
    sha256 "45bda05a03c8c1219550081e21b8e9d3ff833bf0b47b1e1e12cf561c401636d7" => :sierra
    sha256 "43750c886af867ffffefcaa2e21ac3ac2c1d20cb447fce35329320ff8a965b03" => :el_capitan
  end

  depends_on "icu4c" => :recommended
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
