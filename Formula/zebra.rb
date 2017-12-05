class Zebra < Formula
  desc "Information management system"
  homepage "https://www.indexdata.com/zebra"
  url "http://ftp.indexdata.dk/pub/zebra/idzebra-2.1.0.tar.gz"
  sha256 "1544f7929d03153ba79ea171b2128f8cab463ae28407035ae5046f8c4a100ea6"
  revision 2

  bottle do
    sha256 "a0e3e8c14ea3a132fcb50df0c9f5df812030ac92a65c794898023fdc7099e3d3" => :high_sierra
    sha256 "c98b17f3012a43ec0d387ebc6e0db11dad92af2f2fe5c716f731d87a94b79737" => :sierra
    sha256 "19ae1cd0294e94033228ff1d18e2402880b656945fa7396640bffc81d2f8c5b8" => :el_capitan
    sha256 "367e0dad7fb9783b537e320f00e77dac008501ed3432e3e0654043f09a327b08" => :yosemite
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
