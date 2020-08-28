class Zebra < Formula
  desc "Information management system"
  homepage "https://www.indexdata.com/zebra"
  url "http://ftp.indexdata.dk/pub/zebra/idzebra-2.1.4.tar.gz"
  sha256 "f45b0461cf40fafddd97d447695a087be0ba0981c108bf509d4c11f6d1db1ae2"
  revision 4

  livecheck do
    url "https://www.indexdata.com/resources/software/zebra"
    regex(%r{>Latest:</strong>.*?v?(\d+(?:\.\d+)+)<}i)
  end

  bottle do
    sha256 "06034a1fa44ffa343907b961799909eb32556f300129109c05771ad9cc5ef82d" => :catalina
    sha256 "33810ebcbd8ce8a0b3e972a98a9be0a000d064122fc41b58ce748479fb286275" => :mojave
    sha256 "d8c190c482b012b20ad5b2f14fd7c5d59ac4a50aaa75b126871efff83b2999a1" => :high_sierra
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
