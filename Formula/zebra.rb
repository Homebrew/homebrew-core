class Zebra < Formula
  desc "Information management system"
  homepage "https://www.indexdata.com/resources/software/zebra/"
  url "https://ftp.indexdata.com/pub/zebra/idzebra-2.2.6.tar.gz"
  sha256 "694532352cda6ba896607cacd7f090e9fce11e5944e52a2e58ec8d503b4ba75f"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://ftp.indexdata.com/pub/zebra/"
    regex(/href=.*?idzebra[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "7a6cd8e88d334c6e578076d91e6de3cdcbe49579151e4c3f2aa261994ef9538e"
    sha256 arm64_monterey: "d314c9a4b110d1ad1f59168cdaab3933eafc1974300d681e2a1e73e4d90f2a0a"
    sha256 arm64_big_sur:  "cd218c0638852ca83e1e5c71e2a59f0a55bdd7793e85187289a9b9166f27f2fd"
    sha256 ventura:        "33a6649d588718fd1e0b9e10504390c04562b8c5fc40bafb31088d4b107cc61a"
    sha256 monterey:       "3e4e05389b5e6f3b9cd200ea8f5b04411c18867ec10070236af64286f3890cdc"
    sha256 big_sur:        "36ea919889f235dd20e3043c6842aaaf20b8695eba96603a696afd30d0007ea7"
    sha256 x86_64_linux:   "fc92eb9f67ee692c382a50e87c91bf000f4fc7941e3e285ddecd761544be389b"
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
