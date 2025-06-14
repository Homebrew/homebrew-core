class Zebra < Formula
  desc "Information management system"
  homepage "https://www.indexdata.com/resources/software/zebra/"
  url "https://ftp.indexdata.com/pub/zebra/idzebra-2.2.8.tar.gz"
  sha256 "879e402b91912e9074275753f24408ed2ac06b3b7c30b2a2d5a70718c869a542"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://ftp.indexdata.com/pub/zebra/"
    regex(/href=.*?idzebra[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "2aa244713add7f2e0e9e28955dc2403c08b79097cbb85fae1ee7d414324eec39"
    sha256 arm64_sonoma:  "28d8199235458e3a14f907308dfd9c61c1573ce9567d00e15c5d6cd874647660"
    sha256 arm64_ventura: "96f2db9df1abc507135f0fbdce0abb6e1083b3e904f0f63da138aa975f26b63e"
    sha256 sonoma:        "df5e67af2052f424ff930012ccea2688714b433631b054cda2dba1b342815ac9"
    sha256 ventura:       "ceaa8d50e44bf81722f851f447aef180dfb7b817c496aca1c75c918c5b4dcbe0"
    sha256 arm64_linux:   "9a09903d831dcaf5a8f0292d08f882ae8162820571f3614fe9247afe2a2fa4d6"
    sha256 x86_64_linux:  "80fa4c353aa9cb8223576e8a43f4d627051a78a68ede72d8876f93607c2d89e9"
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
