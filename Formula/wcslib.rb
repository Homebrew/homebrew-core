class Wcslib < Formula
  desc "Library and utilities for the FITS World Coordinate System"
  homepage "https://www.atnf.csiro.au/people/mcalabre/WCS/"
  url "https://www.atnf.csiro.au/pub/software/wcslib/wcslib-7.9.tar.bz2"
  sha256 "beff8c1f0e8600078813c032d1afcd9cb305c31f567567434824233d582aba58"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?wcslib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3f6b7e50b0fd00675b6dd093b140533dc19f5b1e1298ea880fa1efb3d7939221"
    sha256 cellar: :any,                 arm64_big_sur:  "9b0c79918950b07c469e52173c52a5c857cf2394fe99c730029b34799422d216"
    sha256 cellar: :any,                 monterey:       "14aaea9146428150c32b6f26d25ed741e4861bd80812872e265d2fc3bc3e9e13"
    sha256 cellar: :any,                 big_sur:        "9cd921c6a11d5075bd1624f08f6676fc608331012b9a26898cba8163738dfcce"
    sha256 cellar: :any,                 catalina:       "be4df383d03584640fb3a40abf50c77ccc82e0157f8d15e08aec02b78564a9e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "779f37d90e851900aaa0e71ca51904101f40018e2aa1ca382c0a3b95fb4bf268"
  end

  depends_on "cfitsio"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-cfitsiolib=#{Formula["cfitsio"].opt_lib}",
                          "--with-cfitsioinc=#{Formula["cfitsio"].opt_include}",
                          "--without-pgplot",
                          "--disable-fortran"
    system "make", "install"
  end

  test do
    piped = "SIMPLE  =" + (" "*20) + "T / comment" + (" "*40) + "END" + (" "*2797)
    pipe_output("#{bin}/fitshdr", piped, 0)
  end
end
