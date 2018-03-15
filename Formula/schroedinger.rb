class Schroedinger < Formula
  desc "High-speed implementation of the Dirac codec"
  homepage "https://launchpad.net/schroedinger"
  url "https://launchpad.net/schroedinger/trunk/1.0.11/+download/schroedinger-1.0.11.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/s/schroedinger/schroedinger_1.0.11.orig.tar.gz"
  sha256 "1e572a0735b92aca5746c4528f9bebd35aa0ccf8619b22fa2756137a8cc9f912"

  bottle do
    cellar :any
    rebuild 1
    sha256 "1e9953cbef67e87a7ca9ebecfcc4af5f0eb2261d17f3a1195386b7512b9312be" => :high_sierra
    sha256 "7d2d6d343f571e21f27ce5c13645ebe7039e4d45d2b96dba550f6383185c18f6" => :sierra
    sha256 "1b990c49b7d72f3030bcee52bf70094a6cf16111867565cdb7541f670636cf05" => :el_capitan
    sha256 "5b1355803b730a9727c959261f0e2afc217f77502eac88120f77941c5cf373db" => :yosemite
    sha256 "64042317d9919652ab8577cec94435fb15d8eae3ad960196fc54bf9499b7c30e" => :mavericks
  end

  head do
    url "lp:schroedinger", :using => :bzr

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "orc"

  def install
    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    # The test suite is known not to build against Orc >0.4.16 in Schroedinger 1.0.11.
    # A fix is in upstream, so test when pulling 1.0.12 if this is still needed. See:
    # https://www.mail-archive.com/schrodinger-devel@lists.sourceforge.net/msg00415.html
    inreplace "Makefile" do |s|
      s.change_make_var! "SUBDIRS", "schroedinger doc tools"
      s.change_make_var! "DIST_SUBDIRS", "schroedinger doc tools"
    end

    system "make", "install"
  end
end
