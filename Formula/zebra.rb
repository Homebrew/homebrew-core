class Zebra < Formula
  desc "Information management system"
  homepage "https://www.indexdata.com/resources/software/zebra/"
  url "https://ftp.indexdata.com/pub/zebra/idzebra-2.2.5.tar.gz"
  sha256 "747714b33b653cbe5697193703b9955489fa2f51597433f9b072ab2bf9cf92bb"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://ftp.indexdata.com/pub/zebra/"
    regex(/href=.*?idzebra[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "e5031d8103e0a12a8250de2075d552577c3920e6dd5910506c126ad78339c2d2"
    sha256 arm64_monterey: "8bede656eb92a62100fbef7242bc5983698621e2e197bbcae466ab9f3ff2c51d"
    sha256 arm64_big_sur:  "3f306cc62317d8a0ace3904ea87cfbe2b87b86eb1b8a1261650d2142ed9670cd"
    sha256 ventura:        "11256e93155452cc87c258f460ec2360d35bbbdeea07db933445523fa0c77a43"
    sha256 monterey:       "4edf6fa6edd68cdd84f0160b2da734a11d1ea9ee3dba66f123d3a67786c8d6db"
    sha256 big_sur:        "c4bcb8868fd1ad665e0b3793f63c3c26a2faf94be04c5bacc6cd3db12d6661d6"
    sha256 catalina:       "f18e747b339b6df99dca4aa709d2545575a0f3f5cad7f1d1f76b9544ea7b8a39"
    sha256 x86_64_linux:   "943a68df4bb5c465878db259e1865c9b181fc58b9af18eb57f6db5cbb5432363"
  end

  depends_on "icu4c"
  depends_on "yaz"

  uses_from_macos "bzip2"
  uses_from_macos "expat"
  uses_from_macos "libxcrypt"
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "zlib"

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
