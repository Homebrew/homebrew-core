class Wcslib < Formula
  desc "Library and utilities for the FITS World Coordinate System"
  homepage "https://www.atnf.csiro.au/people/mcalabre/WCS/"
  url "https://www.atnf.csiro.au/people/mcalabre/WCS/wcslib-8.3.tar.bz2"
  sha256 "431ea3417927bbc02b89bfa3415dc0b4668b0f21a3b46fb8a3525e2fcf614508"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?wcslib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b58519295a6f5324492a6ab2cb85c88757d03341a7aca1da1ebf411c2347eaa2"
    sha256 cellar: :any,                 arm64_sonoma:  "2bc1c82b8c69f67c15d8ae2c483060cf79b17e299fc71a925aa1fd27960f2288"
    sha256 cellar: :any,                 arm64_ventura: "aabc26c024db1b46aabd91df3e6e644ed4c30c66e4a3eb0df70afa694ec51593"
    sha256 cellar: :any,                 sonoma:        "8bb35f89b28e53fdba267d500b006b0c1d671eb59be4cb491ce91a5be1aab085"
    sha256 cellar: :any,                 ventura:       "342018d1233c04c9f057330b3041fc13e4a2ac6a67852f16b87ec404589d5576"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c269ab6085a158ee39f20cbb4eaff0d5f77f7f9022969c49e7b5accc58acd0d"
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
    piped = "SIMPLE  =" + (" "*20) + "T / comment" + (" "*40) + "END" + (" "*2797)
    pipe_output("#{bin}/fitshdr", piped, 0)
  end
end
