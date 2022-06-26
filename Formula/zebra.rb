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
    sha256 arm64_monterey: "3151e5dcd9a07585d8f6d4f81235394e665a2443c35a45a89f673801c6150971"
    sha256 arm64_big_sur:  "eb74e46a14ff57b506bd931116576cd0254274ea64538ee694cd2a1f87f0f09c"
    sha256 monterey:       "b09a16015fa21a43563b01a182c6fa7ccfe277cba465f07f01c770ee36b8de11"
    sha256 big_sur:        "f03be76a850297ab5ca3b56f989f8cc2ca05034e83be744cf46ea38d903ecacb"
    sha256 catalina:       "56d4d4d9606a9f1da02ec47aa53d06d87e6d216b66dbe90510dff70a9f3313b5"
    sha256 x86_64_linux:   "1c46c43a552fc8e9572efa1b294e22b2635c089417d7d0e33c79de3c0e6868b8"
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
