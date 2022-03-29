class Zebra < Formula
  desc "Information management system"
  homepage "https://www.indexdata.com/resources/software/zebra/"
  url "https://ftp.indexdata.com/pub/zebra/idzebra-2.2.3.tar.gz"
  sha256 "85ade449d161d97df47d4a8910a53a5ea3bd5e3598b6189d86fc8986a8effea4"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://ftp.indexdata.com/pub/zebra/"
    regex(/href=.*?idzebra[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "cd2e9e694ed1b71aa2ad0cc29b542d24f6760ff31e815c34382d29201e76bc2a"
    sha256 arm64_big_sur:  "051652cbbe88cff3f1fc2b7fd7b21e67d09f7544b61a689ecde155457fcadb29"
    sha256 monterey:       "a3cd36cd15f5a012207aed8aaa48fc7b547e16d08e43c35f6c062ae219f9590f"
    sha256 big_sur:        "554b0d6622e3389395412417585b0d35c7c4abf37369d4c01ab414cdfb181e4c"
    sha256 catalina:       "42a4a51e46fe3168a7a07628916ad2968ab9831633383ce2dbcefc3033dc8691"
  end

  depends_on "icu4c"
  depends_on "yaz"

  uses_from_macos "bzip2"
  uses_from_macos "expat"
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
