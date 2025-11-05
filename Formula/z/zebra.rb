class Zebra < Formula
  desc "Information management system"
  homepage "https://www.indexdata.com/resources/software/zebra/"
  url "https://ftp.indexdata.com/pub/zebra/idzebra-2.2.8.tar.gz"
  sha256 "879e402b91912e9074275753f24408ed2ac06b3b7c30b2a2d5a70718c869a542"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://ftp.indexdata.com/pub/zebra/"
    regex(/href=.*?idzebra[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "fa56a6589bd080ce7f00036367b5e3c11a6824ca017916f6b7f7c6005fc2e39f"
    sha256 arm64_sequoia: "6c71c081a213d5046e6d613ea4333531b5d39feb4272efb9839588c129116b74"
    sha256 arm64_sonoma:  "b7de9cf32f5334047d823568581d130fbf2e5f176decaa2298b4690165b0596e"
    sha256 sonoma:        "59860258d3f27cda8f478bb0fdc19ac1bc4b4fce26e49d5ddfb9ab28f580ca54"
    sha256 arm64_linux:   "c4e79f04860b12a1b17154a42adf7dceaf7ef47e89e932cecea4c80971a6a38b"
    sha256 x86_64_linux:  "3bf2b3a934faa8509dfff154342d362dc309519dd09fd5035a393d3701a5a581"
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
