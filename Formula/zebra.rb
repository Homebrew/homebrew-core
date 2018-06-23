class Zebra < Formula
  desc "Information management system"
  homepage "https://www.indexdata.com/zebra"
  url "http://ftp.indexdata.dk/pub/zebra/idzebra-2.1.3.tar.gz"
  sha256 "5975c054a4cf50fb97d261b239f6f04f65dec7a2f72022b5abadea4e64405ee3"
  revision 3

  bottle do
    sha256 "a2e63e5a50737a0f4cb291287a8a0279a8e197afa0fc4702576f7eab5ed8b6b0" => :high_sierra
    sha256 "162c2bd1cbc39c9ec9f44417a88dfdbc99b0b542a38d554a5e76c8e92907f334" => :sierra
    sha256 "a02d6c1b2ac9c5b5917c6ba8f8a7ea8c813b05dddf60def322f00201df107d75" => :el_capitan
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
