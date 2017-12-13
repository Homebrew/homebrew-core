class Zebra < Formula
  desc "Information management system"
  homepage "https://www.indexdata.com/zebra"
  url "http://ftp.indexdata.dk/pub/zebra/idzebra-2.1.3.tar.gz"
  sha256 "5975c054a4cf50fb97d261b239f6f04f65dec7a2f72022b5abadea4e64405ee3"

  bottle do
    sha256 "3f63fc7a8484ed1ac791d01857fcdc5a5b61a9fce74b7138cea8bb4e90e08733" => :high_sierra
    sha256 "82c3f0b26e247d709131695563433e9e935b67b495dd283664d3431a38e5adb0" => :sierra
    sha256 "d9eca4b41f3d070bf99adbfd1de09ec494b93d0cb11d10b91a51009618bd2b8c" => :el_capitan
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
