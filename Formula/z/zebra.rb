class Zebra < Formula
  desc "Information management system"
  homepage "https://www.indexdata.com/resources/software/zebra/"
  url "https://ftp.indexdata.com/pub/zebra/idzebra-2.2.7.tar.gz"
  sha256 "b465ffeb060f507316e6cfc20ebd46022472076d0d4e96ef7dab63e798066420"
  license "GPL-2.0-or-later"
  revision 3

  livecheck do
    url "https://ftp.indexdata.com/pub/zebra/"
    regex(/href=.*?idzebra[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "2dab60e1b3c95616ac9c048aec209087be376c4651d93a5dc7345d26a5947ef9"
    sha256 arm64_sonoma:  "aafbef27a3a99cd0b17e9a66cf72945515ab2f6bbba0cd328b63899214178608"
    sha256 arm64_ventura: "5d89124eaad48daa344dd50b9c902c2e97f4b2aa7ea72dd3d1e8a5b1c5fb36fd"
    sha256 sonoma:        "d8e0f12a009e66ed621d5a66e3284950f2c8d882f35f41fb3f0b65ca0a41a45b"
    sha256 ventura:       "71ea2bebec1b10f9e9b70859b3f26701e138936b14e16d2ddfa6ae7b68c797fd"
    sha256 x86_64_linux:  "395aea132ec9ed03c2346a9237a701d55095bbe1d68f58b9ba788eeaf4bcac20"
  end

  depends_on "icu4c@75"
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
