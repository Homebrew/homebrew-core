class Wcslib < Formula
  desc "Library and utilities for the FITS World Coordinate System"
  homepage "https://www.atnf.csiro.au/people/mcalabre/WCS/"
  url "https://www.atnf.csiro.au/pub/software/wcslib/wcslib-6.3.tar.bz2"
  sha256 "4c37f07d64d51abaf30093238fdd426a321ffaf5a9575f7fd81e155d973822ea"

  bottle do
    cellar :any
    sha256 "791f633e087db6056f23904df39a7b0489a7c18c2fea5e3e25c71bf7365518e1" => :mojave
    sha256 "313a28f2170b0622ea7f72fe4371894be0ffb79663541bfeb5ed51c6a02571df" => :high_sierra
    sha256 "98ce5c443e70f687b3754f7ab01fca8248ab760d76145da546a46132e67bd7de" => :sierra
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
