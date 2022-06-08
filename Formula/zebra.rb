class Zebra < Formula
  desc "Information management system"
  homepage "https://www.indexdata.com/resources/software/zebra/"
  url "https://ftp.indexdata.com/pub/zebra/idzebra-2.2.4.tar.gz"
  sha256 "04a00d7af3a43debecd764f8ba3a1b0b460cc0a1eb5a86e46e30c98c718f69bc"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://ftp.indexdata.com/pub/zebra/"
    regex(/href=.*?idzebra[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "0d08d76d0ef45a572673b738cc53cc93eb09a02480962bf6d34d57cb2da00661"
    sha256 arm64_big_sur:  "011c175d082719c8f52007a216c8f25eb444243dcf191510d20acc683b942d3b"
    sha256 monterey:       "3a9ae308213d53da1210f33dc0c942a5b452c1cb92e7cce606ef9298bed177af"
    sha256 big_sur:        "fb1792f314dc578f4367f72959f02cb090c62e0abd35105dbeb7dc008de807ae"
    sha256 catalina:       "21f7799240d6b2611cc003dc32bce5f9be51759777d51d46cbba6fb3dd4e59a1"
    sha256 x86_64_linux:   "81732c0caf9eb5541275b1e4028dcb50becd5ac4cc1bacc0d6189fc4a3827cef"
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
