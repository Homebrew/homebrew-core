class Zebra < Formula
  desc "Information management system"
  homepage "https://www.indexdata.com/zebra"
  url "http://ftp.indexdata.dk/pub/zebra/idzebra-2.1.0.tar.gz"
  sha256 "1544f7929d03153ba79ea171b2128f8cab463ae28407035ae5046f8c4a100ea6"

  bottle do
    sha256 "451f74b7153d3222d4b85d6186a870fec1795a5a4fcf93187cd0944edd182b08" => :sierra
    sha256 "74fc6d4d0364612544054680bc7fc93031de6d641beaf18928ba7c8911539216" => :el_capitan
    sha256 "b1839fc31b21101775b53ae9f6a284c0ef6316be7393b1c50a8b3836c1e08a73" => :yosemite
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
