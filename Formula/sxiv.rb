class Sxiv < Formula
  desc "Simple X Image Viewer"
  homepage "https://github.com/muennich/sxiv"
  url "https://github.com/muennich/sxiv/archive/v25.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/s/sxiv/sxiv_25.orig.tar.gz"
  sha256 "16d1aca1a179e1c0875844efe2e51cfa396a4403467c389f7e9221a733ae5e26"
  head "https://github.com/muennich/sxiv.git"

  bottle do
    cellar :any
    sha256 "50df305ce82fbe25234ebfbd1a3482aba25f7594104e34b2232cb86b18ff4ea5" => :catalina
    sha256 "997fa90908e0bdb205de81a7ebdaf77cc4cbd36e5545b955a60394fb59abdcc5" => :mojave
    sha256 "b89d70ec319463f27d1b8a75318f96c5f6032f50a35e64508e27564af9c7a98a" => :high_sierra
    sha256 "77e317584075a5bf67d5426c075a2a72a2fe5a3134341a633c81a4256ff5af6e" => :sierra
  end

  depends_on "giflib"
  depends_on "imlib2"
  depends_on "libexif"
  depends_on :x11

  def install
    system "make", "PREFIX=#{prefix}", "AUTORELOAD=nop", "CPPFLAGS=-I/opt/X11/include", "LDFLAGS=-L/opt/X11/lib", "LDLIBS=-lpthread", "install"
  end

  test do
    system "#{bin}/sxiv", "-v"
  end
end
