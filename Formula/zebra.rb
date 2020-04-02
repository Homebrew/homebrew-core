class Zebra < Formula
  desc "Information management system"
  homepage "https://www.indexdata.com/zebra"
  url "http://ftp.indexdata.dk/pub/zebra/idzebra-2.1.4.tar.gz"
  sha256 "f45b0461cf40fafddd97d447695a087be0ba0981c108bf509d4c11f6d1db1ae2"
  revision 3

  bottle do
    sha256 "e67fb475fd3468f8622460b1e57cccb265017cab4173a080334a015e36c0621b" => :catalina
    sha256 "dd784ac02afbfdbda3786a0a76007f03b6e2d49f62881240f0511a5cde31d4c8" => :mojave
    sha256 "2828bc307310857dc7aaf504ac5d4be5404cae0cadd10825197d671a41ab1bb3" => :high_sierra
    sha256 "d0bba81ae80e339d30ea0e0741e8547a0c3ae21ee190b6f0ff6171fa8fd0fbc4" => :sierra
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
