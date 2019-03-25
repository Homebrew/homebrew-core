class Sxiv < Formula
  desc "Simple X Image Viewer"
  homepage "https://github.com/muennich/sxiv"
  url "https://github.com/muennich/sxiv/archive/v25.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/s/sxiv/sxiv_25.orig.tar.gz"
  sha256 "16d1aca1a179e1c0875844efe2e51cfa396a4403467c389f7e9221a733ae5e26"
  head "https://github.com/muennich/sxiv.git"

  bottle do
    cellar :any
    sha256 "ba5bc2b563d91d1415f0f841606b9cfb954de246eb15062b5c1bd976e8073886" => :mojave
    sha256 "61d85801587ee6d3158407ae65cd0bece03a08b2e8f99d9e7568b7ddb3b2daee" => :high_sierra
    sha256 "606057791d4785165f78ae964bfa990b005d5f0cc3e51f19f64438c29b2670f5" => :sierra
    sha256 "16a9ac152429a736db62dc0a2ac34f1b4d70c11b3de10f856bece78acf20a9a1" => :el_capitan
    sha256 "de711fb6eb1c6ac0093ad182dd820c9debdb5d08ce03430de6462fbf9568c5e3" => :yosemite
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
