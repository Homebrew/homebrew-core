class Zebra < Formula
  desc "Information management system"
  homepage "https://www.indexdata.com/resources/software/zebra/"
  url "https://ftp.indexdata.com/pub/zebra/idzebra-2.2.10.tar.gz"
  sha256 "9ac047f9a4b402722a697062680cdc8fe4a9232da58de0976d7424a79208ad98"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://ftp.indexdata.com/pub/zebra/"
    regex(/href=.*?idzebra[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "19bbf8d4ccb9a2101ba988660c99f28619faadf473dc5841385cd1946f8327b9"
    sha256 arm64_sequoia: "8889a6a7ad2c160e224033529b6395f61de7619d8a603992ecb0edc606baa02b"
    sha256 arm64_sonoma:  "5a8bab3d5c6af8415011b994f40f1618aa685668898bbc3994fd8f3ca7e38001"
    sha256 sonoma:        "d5fd63bd6a150619f6ffbe4e314f286eabe3e999423e9cb9f35b71d86e681547"
    sha256 arm64_linux:   "eb2d58aaffda0097ed21f908680cc33e649366997d5dcafaf89fa08c0b67af5b"
    sha256 x86_64_linux:  "3559c2ea4ab4cea38fc905077c4873dd471586252375aaa2bc744a5037694b29"
  end

  depends_on "pkgconf" => :build

  depends_on "icu4c@78"
  depends_on "yaz"

  uses_from_macos "bzip2"
  uses_from_macos "expat"
  uses_from_macos "libxcrypt"
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
