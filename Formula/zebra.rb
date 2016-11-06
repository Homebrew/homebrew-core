class Zebra < Formula
  desc "Information management system"
  homepage "https://www.indexdata.com/zebra"
  url "http://ftp.indexdata.dk/pub/zebra/idzebra-2.0.62.tar.gz"
  sha256 "f14e34509c0b7d6df98f83ff05cf81b8b82919a5a3cdcccf42125caf30f5a7f0"
  revision 1

  bottle do
    sha256 "46980aae467c0af7310a3365849c4e03e101f7d86fba056047281a02551182c9" => :sierra
    sha256 "643a89f3995c4611c0f6a73ad40b8d7b69b7bd6b6c90cd7f3afd54d25857fcbd" => :el_capitan
    sha256 "6989af81eba969691414edad64faa3525e367c5315660933c0d12c95bd70694b" => :yosemite
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
