class Zebra < Formula
  desc "Information management system"
  homepage "https://www.indexdata.com/resources/software/zebra/"
  url "https://ftp.indexdata.com/pub/zebra/idzebra-2.2.7.tar.gz"
  sha256 "b465ffeb060f507316e6cfc20ebd46022472076d0d4e96ef7dab63e798066420"
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url "https://ftp.indexdata.com/pub/zebra/"
    regex(/href=.*?idzebra[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "ed5577f3ddf35fa49cbc6f341de27307e871ce01899f3fceee962431bbf9a40e"
    sha256 arm64_ventura:  "0490893dedda889a386fa7d796f8a48ecd2cde6079c0dfbc8280fc1cc9a59749"
    sha256 arm64_monterey: "fa41931108751f1e96d79b03a914e180cf839775625448268006c63aa07de875"
    sha256 sonoma:         "41cc4509c63ab4c111937bd04d593cf0afa71af3d81c7d5ee7f4b6bc9fd9546d"
    sha256 ventura:        "778f56686d0e428122392a68d5f804612701826bab545e8edab2258512e9207f"
    sha256 monterey:       "6a135417aa799bf98438651ad4efb6b5429be948b6b7d02c0051a5e8b4960d15"
    sha256 x86_64_linux:   "1038933d7519ce99529c371bfd3d08759626bf84d81a01e65f2154d08e5fcf9a"
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
