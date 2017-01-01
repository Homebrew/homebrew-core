class Zebra < Formula
  desc "Information management system"
  homepage "https://www.indexdata.com/zebra"
  url "http://ftp.indexdata.dk/pub/zebra/idzebra-2.0.62.tar.gz"
  sha256 "f14e34509c0b7d6df98f83ff05cf81b8b82919a5a3cdcccf42125caf30f5a7f0"
  revision 2

  bottle do
    sha256 "2272316dbbc77594631a29b6761743e05b6392b6b8740b36b4566c2830dc5da7" => :sierra
    sha256 "1dadf5775202ed03816d2832c2eed6da9188dea493d44e0ec5b9d46bec2df196" => :el_capitan
    sha256 "c90da9974618b7ee9b2ec7a7dcb9bd6646d2590a3bb9eda1e5bd0cede98c734f" => :yosemite
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
