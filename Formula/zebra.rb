class Zebra < Formula
  desc "Information management system"
  homepage "https://www.indexdata.com/zebra"
  url "http://ftp.indexdata.dk/pub/zebra/idzebra-2.0.62.tar.gz"
  sha256 "f14e34509c0b7d6df98f83ff05cf81b8b82919a5a3cdcccf42125caf30f5a7f0"

  bottle do
    sha256 "d173949e4b9b303dfff659a0556b4fa07b8e54cb715cdb82801ca23646c3f598" => :sierra
    sha256 "8a03047d1e255f82c63f52f57dff69cbad70950c1910317ec1075449b0512f0a" => :el_capitan
    sha256 "6b06e7cef64fcb2b9625d3ce03b3cbf5c1f83d2a962406562a38736628647198" => :yosemite
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
