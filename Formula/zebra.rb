class Zebra < Formula
  desc "Information management system"
  homepage "https://www.indexdata.com/zebra"
  url "http://ftp.indexdata.dk/pub/zebra/idzebra-2.1.4.tar.gz"
  sha256 "f45b0461cf40fafddd97d447695a087be0ba0981c108bf509d4c11f6d1db1ae2"
  revision 1

  bottle do
    sha256 "89cf3b3212437b5b46739abc62b7fc5b36508ad64a76a285cdce6a44bdac3fd9" => :mojave
    sha256 "ca01021446ea99a1faa53b4c3e226c2297693dfe95646decbff7e70bbb174956" => :high_sierra
    sha256 "1ed8f30f526b4c52279dbfdd7e4fcf5f64d474f3697a3c87a81f1051a08bfe3b" => :sierra
    sha256 "fff03bacc2fdde279fc891f1ebe8ba4a6c50285d2697eebf50634712cdad1753" => :el_capitan
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
