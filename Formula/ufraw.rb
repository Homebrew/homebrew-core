class Ufraw < Formula
  desc "Unidentified Flying RAW: RAW image processing utility"
  homepage "http://ufraw.sourceforge.net"
  url "https://downloads.sourceforge.net/project/ufraw/ufraw/ufraw-0.22/ufraw-0.22.tar.gz"
  sha256 "f7abd28ce587db2a74b4c54149bd8a2523a7ddc09bedf4f923246ff0ae09a25e"

  bottle do
    rebuild 1
    sha256 "c959fb61040278bd42857a76c7ae8d8be92ca71a08509a0523b6ff56e36af578" => :sierra
    sha256 "a38d7b3bfc6555642af8c17673e848884f38c35bc94aa121d675daf5fa923cde" => :el_capitan
    sha256 "8553e9e81b43de2a68fdac5ee8b6ea1ff319d0748b0d8c34d179f514d1f30e92" => :yosemite
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

  fails_with :llvm do
    cause "Segfault while linking"
  end

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
