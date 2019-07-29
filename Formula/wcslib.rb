class Wcslib < Formula
  desc "Library and utilities for the FITS World Coordinate System"
  homepage "https://www.atnf.csiro.au/people/mcalabre/WCS/"
  url "https://www.atnf.csiro.au/pub/software/wcslib/wcslib-6.3.tar.bz2"
  sha256 "4c37f07d64d51abaf30093238fdd426a321ffaf5a9575f7fd81e155d973822ea"

  bottle do
    cellar :any
    sha256 "5e88e55e09a2bec804e8052ea6257abb899ee0a9e42995694634ca8a4fb3e662" => :mojave
    sha256 "56fd6ceb75754b0840d80af9c3d902e6188aa4b5eb5100ddaecd765219c9cd6a" => :high_sierra
    sha256 "e3c3a0f23f756f045cc9dbafeeed7a7df4d0b2c84c241f74ac6a8496921ab0f5" => :sierra
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
