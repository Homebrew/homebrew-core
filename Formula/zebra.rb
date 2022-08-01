class Zebra < Formula
  desc "Information management system"
  homepage "https://www.indexdata.com/resources/software/zebra/"
  url "https://ftp.indexdata.com/pub/zebra/idzebra-2.2.5.tar.gz"
  sha256 "747714b33b653cbe5697193703b9955489fa2f51597433f9b072ab2bf9cf92bb"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://ftp.indexdata.com/pub/zebra/"
    regex(/href=.*?idzebra[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "d2d4d08210da41a8cee406e186797b38f8b3e04c9529c3abb27b9bcd79e0e380"
    sha256 arm64_big_sur:  "08bdad0b345de815886ba491efc05c64301de4f58db1d18b2ac1467da2f1473c"
    sha256 monterey:       "9327880be4912d03219f7a691b59560bf33a33dfe1f994275bc7ec9ede54a10d"
    sha256 big_sur:        "9f4f272f7a6d0de6184755bd8304c3c00c9c8ed10d5143f8048f2ff528398854"
    sha256 catalina:       "23adf3398ce56fbcb527f772362b2d3b551684470563ea4911d06dde14e43b29"
    sha256 x86_64_linux:   "384a18ddb1e2ab16a1fc679cef45fea988b6df9f93759aaaeeebdec71ba509d5"
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
