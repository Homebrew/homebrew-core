class Zebra < Formula
  desc "Information management system"
  homepage "https://www.indexdata.com/zebra"
  url "http://ftp.indexdata.dk/pub/zebra/idzebra-2.2.2.tar.gz"
  sha256 "513c2bf272e12745d4a7b58599ded0bc1292a84e9dc420a32eb53b6601ae0000"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://www.indexdata.com/resources/software/zebra"
    regex(%r{>Latest:</strong>.*?v?(\d+(?:\.\d+)+)<}i)
  end

  bottle do
    sha256 "3521e4cde145c7ebd38c406d4a0c3a75d8f9154fe8a91ee63c62765befefb5d7" => :big_sur
    sha256 "68e15eda361139139937655b494e3726b1c9236480ff3ab6e37c8e120b0f2c5f" => :arm64_big_sur
    sha256 "b78b4ca52c9274c42692d190beb13c9b3709b8cb610831ee04bae42bf1ef4c04" => :catalina
    sha256 "0c4967b8025621b5c3bc343329a2f01e07292163df9151c1432c70886dc81500" => :mojave
    sha256 "a7f24384ddd17dda271a6c44a9f2db5f91ba3ee50944fbccc156ca9cd6387b3e" => :high_sierra
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
