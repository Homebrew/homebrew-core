class Wcslib < Formula
  desc "Library and utilities for the FITS World Coordinate System"
  homepage "https://www.atnf.csiro.au/people/mcalabre/WCS/"
  url "https://www.atnf.csiro.au/pub/software/wcslib/wcslib-7.2.tar.bz2"
  sha256 "63959eb4859517a1ecca48c91542318bebeed62e4a1663656de9a983af376e39"
  revision 1

  bottle do
    cellar :any
    sha256 "f433b50d1145dea6a09d3cc1ff5f6fe070bdedcca196789c486dc1e7d299da3d" => :catalina
    sha256 "da1a57d86d835e3f3f62edc8e0f124b10c5a938070b991c079c515199429cb18" => :mojave
    sha256 "c5a4d124778c74f2e0d618f0aa8ffff11531180b9335e10b4f1ed499086bf3a0" => :high_sierra
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
    piped = "SIMPLE  =" + " "*20 + "T / comment" + " "*40 + "END" + " "*2797
    pipe_output("#{bin}/fitshdr", piped, 0)
  end
end
