class Zebra < Formula
  desc "Information management system"
  homepage "https://www.indexdata.com/resources/software/zebra/"
  url "https://ftp.indexdata.com/pub/zebra/idzebra-2.2.7.tar.gz"
  sha256 "b465ffeb060f507316e6cfc20ebd46022472076d0d4e96ef7dab63e798066420"
  license "GPL-2.0-or-later"
  revision 4

  livecheck do
    url "https://ftp.indexdata.com/pub/zebra/"
    regex(/href=.*?idzebra[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "400c8de8a1d7071b69e6b511ea50bcde9acd8132bf6fd67706d47955caf083c7"
    sha256 arm64_sonoma:  "3e9d34d91050236c2276a5883fd5468019581df138bf7c9452e7097f926cbc94"
    sha256 arm64_ventura: "8daed2232e33c838bb333ea7e1429153578bcc1383171d8684e4e474345c0a88"
    sha256 sonoma:        "27b8e0d296adb17a5756452180750f15bfa8db633728b5176bd56b49b540214a"
    sha256 ventura:       "906e808a4541d0cf331893443ee5c2b30b4032fce3ef886d80527c34dd825674"
    sha256 x86_64_linux:  "e9fa00ff2ff605e9070fc39f74fb24f19751c73db94e43f3a97025e28052d507"
  end

  depends_on "icu4c@76"
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
