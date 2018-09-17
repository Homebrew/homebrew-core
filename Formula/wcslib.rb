class Wcslib < Formula
  desc "Library and utilities for the FITS World Coordinate System"
  homepage "https://www.atnf.csiro.au/people/mcalabre/WCS/"
  url "https://www.atnf.csiro.au/pub/software/wcslib/wcslib-5.19.1.tar.bz2"
  sha256 "59b9f0e5a2c040773cc846c684d84c09b986c1393e97b378a41b92d9d3df0f98"

  bottle do
    cellar :any
    sha256 "bb97c202d67ecf98cf74431e6eef36a7e4272e7549765ffa34139daff5173b07" => :mojave
    sha256 "3f65a03fa9f939560f4bc2776d1c4349a641b8e5386fae073a551413049bfbde" => :high_sierra
    sha256 "a4a31772504b45bd2bd7b4a955bc2624c6c1849ba56cf9382d4f65765b7627c8" => :sierra
    sha256 "b465fcf1d06195230abb08abf6dfe38aec48707a5f78bb9bc006f83cd866c006" => :el_capitan
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

    # Currently doesn't support parallel make.  Patch sent to author 2018/08/31.
    # Author (mcalabre@atnf.csiro.au) expects to integrate by end of 2018/09.
    # Patch: https://gist.github.com/dstndstn/0492f69eb27a11cdd622d01105643dd0
    ENV.deparallelize
    system "make"
    system "make", "install"
  end

  test do
    piped = "SIMPLE  =" + " "*20 + "T / comment" + " "*40 + "END" + " "*2797
    pipe_output("#{bin}/fitshdr", piped, 0)
  end
end
