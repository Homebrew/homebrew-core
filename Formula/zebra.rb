class Zebra < Formula
  desc "Information management system"
  homepage "https://www.indexdata.com/resources/software/zebra/"
  url "https://ftp.indexdata.com/pub/zebra/idzebra-2.2.7.tar.gz"
  sha256 "b465ffeb060f507316e6cfc20ebd46022472076d0d4e96ef7dab63e798066420"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://ftp.indexdata.com/pub/zebra/"
    regex(/href=.*?idzebra[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "0f4eaa1599579ff8fb91df4daffdae399a9124687b1822bf9927406153020f27"
    sha256 arm64_monterey: "d794e304a3a78b98bdeb991c86e20d44d06fc91fece39eb9fa72cedf9a9ad61e"
    sha256 arm64_big_sur:  "406b5dcefcb72c220c812573a5330b13eca277be52b0ae552b191c327d2deacb"
    sha256 ventura:        "ac364f090fde9a0d88df2fb9f9aeef522dad399ad7bf92bc5ef321f2036c9306"
    sha256 monterey:       "17a5be5288b4568497a4a0bd0e592d98fa235ba382d4307e7a8eca2905d64861"
    sha256 big_sur:        "f623a3e76d8a564683b86bdf8b3e743073bb5a849e9b99faa2a763cc2c351def"
    sha256 x86_64_linux:   "caaa71a7fea9ecd017271647f7d8a6d7a7c16f0147eb0ece9fbaf8715363dd1d"
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
