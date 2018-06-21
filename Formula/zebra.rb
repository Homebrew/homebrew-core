class Zebra < Formula
  desc "Information management system"
  homepage "https://www.indexdata.com/zebra"
  url "http://ftp.indexdata.dk/pub/zebra/idzebra-2.1.3.tar.gz"
  sha256 "5975c054a4cf50fb97d261b239f6f04f65dec7a2f72022b5abadea4e64405ee3"
  revision 3

  bottle do
    sha256 "487e9fddecbccdbf58985ee2b9c349fbd88cb108d74b4fb948ebb00ddaecf98e" => :high_sierra
    sha256 "b939f3348f27580805472d5da3ef631728b4b1e0e438cbb0814326ea8362c2bb" => :sierra
    sha256 "630d7efb1da41b6c24beae389a52649d645659564b08a2e321d340182dd5c9bc" => :el_capitan
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
