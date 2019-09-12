class Wcslib < Formula
  desc "Library and utilities for the FITS World Coordinate System"
  homepage "https://www.atnf.csiro.au/people/mcalabre/WCS/"
  url "https://www.atnf.csiro.au/pub/software/wcslib/wcslib-6.4.tar.bz2"
  sha256 "13c11ff70a7725563ec5fa52707a9965fce186a1766db193d08c9766ea107000"

  bottle do
    cellar :any
    sha256 "7576767feb83f577b9b8cd0543d59465fc8c9878602d8e4003802981211d32dd" => :mojave
    sha256 "31fbb2d390351ab6a27bdfc7cad5c521a13c93d95caeb319550d5f32f6bc965f" => :high_sierra
    sha256 "2139f69d161b83857d2768fb5a9dd78d77eb2b94e4c80f6385093a4168228374" => :sierra
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
