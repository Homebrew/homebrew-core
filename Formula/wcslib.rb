class Wcslib < Formula
  desc "Library and utilities for the FITS World Coordinate System"
  homepage "https://www.atnf.csiro.au/people/mcalabre/WCS/"
  url "https://www.atnf.csiro.au/pub/software/wcslib/wcslib-7.3.tar.bz2"
  sha256 "4b01cf425382a26ca4f955ed6841a5f50c55952a2994367f8e067e4183992961"
  license "GPL-3.0"

  bottle do
    cellar :any
    sha256 "a0e15ea5ee23106c24960feed0c7dad6762d8e75cb9d42445c197fb38f079965" => :catalina
    sha256 "d8b3561a7e87031d7d6f8042af1c75f21663874921da17d5061d3ffe558263f1" => :mojave
    sha256 "941ce001ceb21e53dc6af78e8e09ebc52a24b57efcd51c009f8416789674f8ee" => :high_sierra
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
