class Wcslib < Formula
  desc "Library and utilities for the FITS World Coordinate System"
  homepage "https://www.atnf.csiro.au/people/mcalabre/WCS/"
  url "https://www.atnf.csiro.au/pub/software/wcslib/wcslib-7.3.tar.bz2"
  sha256 "4b01cf425382a26ca4f955ed6841a5f50c55952a2994367f8e067e4183992961"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?wcslib\.t.+?WCSLIB v?(\d+(?:\.\d+)+)</im)
  end

  bottle do
    cellar :any
    sha256 "14760499e809a0b5878d03b2f22f15975906fea80bb63b173a35c67645c3654a" => :big_sur
    sha256 "c733b73fe01c146992c2fa05865c631907c61cbc26e5c66980471441c5c7910f" => :arm64_big_sur
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
