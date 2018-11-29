class Zebra < Formula
  desc "Information management system"
  homepage "https://www.indexdata.com/zebra"
  url "http://ftp.indexdata.dk/pub/zebra/idzebra-2.1.4.tar.gz"
  sha256 "f45b0461cf40fafddd97d447695a087be0ba0981c108bf509d4c11f6d1db1ae2"
  revision 1

  bottle do
    sha256 "c2cd8d27e0426422eab75017a53a12635faa8784a9895e86596b59e8e2eb515b" => :mojave
    sha256 "10a073b4fd6f48c197029e1bc736c3299d2a8138690389c5c94fda5a7b091601" => :high_sierra
    sha256 "7afcb8c211cea6a86800470d3018d165a4e4b82205e788998cde061efa6f8944" => :sierra
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
