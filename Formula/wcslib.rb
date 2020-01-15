class Wcslib < Formula
  desc "Library and utilities for the FITS World Coordinate System"
  homepage "https://www.atnf.csiro.au/people/mcalabre/WCS/"
  url "https://www.atnf.csiro.au/pub/software/wcslib/wcslib-7.1.tar.bz2"
  sha256 "f0bb749eb384794501ad3f71cc10d69debcc0dfca2a395ef57062245c9165116"

  bottle do
    cellar :any
    sha256 "3901a6e6a0dccc34459c165fcd2dc07d6229efe3160dcc908dd4e2479d5f8bbe" => :catalina
    sha256 "7d9ebc483a9e1a2b75bf11f68b5175433ecb453f7d8057934313b77ab41dcbcf" => :mojave
    sha256 "a9d982721090b1560e868092bfd97f769993fe87a498138adbc599c519487819" => :high_sierra
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
