class Wcslib < Formula
  desc "Library and utilities for the FITS World Coordinate System"
  homepage "https://www.atnf.csiro.au/people/mcalabre/WCS/"
  url "https://www.atnf.csiro.au/pub/software/wcslib/wcslib-7.1.tar.bz2"
  sha256 "f0bb749eb384794501ad3f71cc10d69debcc0dfca2a395ef57062245c9165116"
  revision 1

  bottle do
    cellar :any
    sha256 "6b13b97c4df588d435da3cb4e09c70b4db1ad2a19c3a15bf5d80108514062904" => :catalina
    sha256 "db830d1e0e3c8b7da3f61d9fb007232703458200b90165a03688dea6b93fcf18" => :mojave
    sha256 "ab7122ab82a0ab67a87f4d51fb08e0d59b9b16309ea7a830707a7207ddfd0b0c" => :high_sierra
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
