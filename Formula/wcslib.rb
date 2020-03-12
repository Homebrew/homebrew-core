class Wcslib < Formula
  desc "Library and utilities for the FITS World Coordinate System"
  homepage "https://www.atnf.csiro.au/people/mcalabre/WCS/"
  url "https://www.atnf.csiro.au/pub/software/wcslib/wcslib-7.2.tar.bz2"
  sha256 "63959eb4859517a1ecca48c91542318bebeed62e4a1663656de9a983af376e39"

  bottle do
    cellar :any
    sha256 "c77749a5e80eaa43fb064377f95c380bd202f04246d3fa3a038556ae000ce3b8" => :catalina
    sha256 "c6825adf78fc4d6221ee0b2faa03e1d0a0c8289baf44ec9cd178c143a54ac5f6" => :mojave
    sha256 "fae6f75ecc5d312b5fd073517392a3e2541dfa4aeb03d0a0f02a64749c2fbe23" => :high_sierra
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
