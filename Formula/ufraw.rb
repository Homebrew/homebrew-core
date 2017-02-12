class Ufraw < Formula
  desc "Unidentified Flying RAW: RAW image processing utility"
  homepage "http://ufraw.sourceforge.net"
  url "https://downloads.sourceforge.net/project/ufraw/ufraw/ufraw-0.22/ufraw-0.22.tar.gz"
  sha256 "f7abd28ce587db2a74b4c54149bd8a2523a7ddc09bedf4f923246ff0ae09a25e"
  revision 1

  bottle do
    sha256 "d77f0f432aa697d644d3a1458a9deeeb7802676a8ee95caa35e32f7bb8919906" => :sierra
    sha256 "86999676fdcad5b68bb5a4de14ed2abc876b468473a61de71480d3464a2deba6" => :el_capitan
    sha256 "dfa07415343481782b646a9b8de3d8fe2d3cbf54820be6fdaac8781c568999bd" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "libpng"
  depends_on "dcraw"
  depends_on "gettext"
  depends_on "glib"
  depends_on "jasper"
  depends_on "jpeg"
  depends_on "libtiff"
  depends_on "little-cms2"
  depends_on "exiv2" => :optional

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-gtk",
                          "--without-gimp"
    system "make", "install"
    (share/"pixmaps").rmtree
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ufraw-batch --version 2>&1")
  end
end
