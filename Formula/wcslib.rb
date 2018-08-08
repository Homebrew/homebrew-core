class Wcslib < Formula
  desc "Library and utilities for the FITS World Coordinate System"
  homepage "https://www.atnf.csiro.au/people/mcalabre/WCS/"
  url "ftp://ftp.atnf.csiro.au/pub/software/wcslib/wcslib-5.18.tar.bz2"
  sha256 "b693fbf14f2553507bc0c72bca531f23c59885be8f7d3c3cb889a5349129509a"

  depends_on "cfitsio"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-cfitsiolib=#{Formula["cfitsio"].opt_lib}",
                          "--with-cfitsioinc=#{Formula["cfitsio"].opt_include}",
                          "--without-pgplot",
                          "--disable-fortran"

    ENV.deparallelize
    system "make"
    system "make", "install"
  end

  test do
    header = "SIMPLE  =                    T / file does conform to FITS standard             END" + " "*2797
    system "echo '" + header + "' | #{bin}/fitshdr"
  end
end
