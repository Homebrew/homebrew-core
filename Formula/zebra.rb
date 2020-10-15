class Zebra < Formula
  desc "Information management system"
  homepage "https://www.indexdata.com/zebra"
  url "http://ftp.indexdata.dk/pub/zebra/idzebra-2.2.0.tar.gz"
  sha256 "897b3e32690519a588fd7b93884939d956df0c3d3d6e46b5c1c48cb159200ffc"

  livecheck do
    url "https://www.indexdata.com/resources/software/zebra"
    regex(%r{>Latest:</strong>.*?v?(\d+(?:\.\d+)+)<}i)
  end

  bottle do
    sha256 "afeaecb814a1b297a58c4785c5407695b7a42a70cb33549799c36ec5be2e4450" => :catalina
    sha256 "6784d0a5e6422f1da04389e08fc792bc9b429fe15e535ca42c3e16ecfc1beddd" => :mojave
    sha256 "0ed9dfd1cb9920547b445c89ddb4c8a41ef4518d713ef953b7602cf8a2c7fa12" => :high_sierra
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
