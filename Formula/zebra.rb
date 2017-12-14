class Zebra < Formula
  desc "Information management system"
  homepage "https://www.indexdata.com/zebra"
  url "http://ftp.indexdata.dk/pub/zebra/idzebra-2.1.3.tar.gz"
  sha256 "5975c054a4cf50fb97d261b239f6f04f65dec7a2f72022b5abadea4e64405ee3"
  revision 1

  bottle do
    sha256 "e8cb66d351d96bc134b200fb1cc01037bb54b3e4654de7321ac9712d99f0d61b" => :high_sierra
    sha256 "9cb17d10d65d97c7db4bc95c63db7339154ea9cae7c6813d608c4d81abd0981e" => :sierra
    sha256 "b08382b7c06f25dc5044fa816f08d70b4a6ca8cd37ac877635e21e3d61eb013e" => :el_capitan
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
