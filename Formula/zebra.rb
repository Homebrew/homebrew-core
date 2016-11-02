class Zebra < Formula
  desc "Information management system"
  homepage "https://www.indexdata.com/zebra"
  url "http://ftp.indexdata.dk/pub/zebra/idzebra-2.0.62.tar.gz"
  sha256 "f14e34509c0b7d6df98f83ff05cf81b8b82919a5a3cdcccf42125caf30f5a7f0"

  bottle do
    sha256 "78f3c46a4a98b6964e989ae0583e3d8b0420e4981803c2fe5fbb8feed9c4b8ea" => :sierra
    sha256 "bcfbe5b360d8cc65c0851123bd8be65563128dfc3ca840f5c0a9b9b18e8f1a4d" => :el_capitan
    sha256 "4723c0bc882ea66416ba7f3af54d227c055c9c940419da44a9c95b1567be4292" => :yosemite
    sha256 "c83e5ca5feeb378ae0220842428fd99731d1b8005f78497b09b5d0342da7bb72" => :mavericks
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
