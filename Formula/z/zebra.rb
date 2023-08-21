class Zebra < Formula
  desc "Information management system"
  homepage "https://www.indexdata.com/resources/software/zebra/"
  url "https://ftp.indexdata.com/pub/zebra/idzebra-2.2.7.tar.gz"
  sha256 "b465ffeb060f507316e6cfc20ebd46022472076d0d4e96ef7dab63e798066420"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://ftp.indexdata.com/pub/zebra/"
    regex(/href=.*?idzebra[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "2c1c575bfbb006d3f14b5c8c195baafe9645ef628a667b525c636b484ba7687d"
    sha256 arm64_monterey: "c728eb75cec0392bca517fec5269b6b58f010863108453d726e09ccd07f31417"
    sha256 arm64_big_sur:  "64789711abef79fff026a85e8fa8cf1fc3e08a12057cfe46947f215f6005fde4"
    sha256 ventura:        "dc998e52eb4015f39637fbacf3b84ecb521d613695dd0aa7225aa36d6abc1662"
    sha256 monterey:       "9bce4f66dd42f152cd4f1920b8e4d9bd4a20ce9c59e36b6876f79658254e8c17"
    sha256 big_sur:        "d5d8c1daf8eee3ec6708883aca253259ade3b1f969ac188f0ea4fe2a86ac18b8"
    sha256 x86_64_linux:   "04dc42ea2bf2529032c1cebbf9fe16a9315a9a99f586d3dbebbacf540a15e65b"
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
