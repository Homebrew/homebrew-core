class Zebra < Formula
  desc "Information management system"
  homepage "https://www.indexdata.com/resources/software/zebra/"
  url "https://ftp.indexdata.com/pub/zebra/idzebra-2.2.7.tar.gz"
  sha256 "b465ffeb060f507316e6cfc20ebd46022472076d0d4e96ef7dab63e798066420"
  license "GPL-2.0-or-later"
  revision 5

  livecheck do
    url "https://ftp.indexdata.com/pub/zebra/"
    regex(/href=.*?idzebra[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "ebc4c8b98b8d0092a14b28a1fc1a3624d25efc739fac4c8c37a24b9cf748dff7"
    sha256 arm64_sonoma:  "c90a4df5cdf059fbc304eb29694295d15aff3c9e938c9f3043b21c0611e231f2"
    sha256 arm64_ventura: "ba641b0bb5af1aeed71f7c74bdd2d23260bc56d5417a16b3c0d2a89545d33122"
    sha256 sonoma:        "89ec7a8767b4ec0897e424efc895c0044a7ec3b974842d5cbc3dc803106db4b5"
    sha256 ventura:       "a7c5848a84b7e0596504c0b234da47f7dfe9580c3bda227256b35698026207b5"
    sha256 arm64_linux:   "5334731b4f819cb37340c235ae68d1e1e5deecb367d16c9be82b7f0131fd7839"
    sha256 x86_64_linux:  "f327f534822726a13ab7d912a3873f915f71c24c701f54675b42077d24212d48"
  end

  depends_on "icu4c@77"
  depends_on "yaz"

  uses_from_macos "bzip2"
  uses_from_macos "expat"
  uses_from_macos "libxcrypt"
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "zlib"

  def install
    system "./configure", "--disable-silent-rules",
                          "--enable-mod-text",
                          "--enable-mod-grs-regx",
                          "--enable-mod-grs-marc",
                          "--enable-mod-grs-xml",
                          "--enable-mod-dom",
                          "--enable-mod-alvis",
                          "--enable-mod-safari",
                          *std_configure_args
    system "make", "install"
  end

  test do
    cd share/"idzebra-2.0-examples/oai-pmh/" do
      system bin/"zebraidx-2.0", "-c", "conf/zebra.cfg", "init"
      system bin/"zebraidx-2.0", "-c", "conf/zebra.cfg", "commit"
    end
  end
end
