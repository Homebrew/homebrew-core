class Wcslib < Formula
  desc "Library and utilities for the FITS World Coordinate System"
  homepage "https://www.atnf.csiro.au/people/mcalabre/WCS/"
  url "https://www.atnf.csiro.au/pub/software/wcslib/wcslib-7.11.tar.bz2"
  sha256 "46befbfdf50cd4953896676a7d570094dc7661e2ae9677b092e7fb13cee3da5f"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?wcslib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ba8a5a2e24278f12c7888731a70c4a71a09a92c2f6fb8ffc07fb4e62fa369bb4"
    sha256 cellar: :any,                 arm64_big_sur:  "236fb88295dfe22ed4859cb53c90d6c611c8782ae626ae90895686829b98f6a3"
    sha256 cellar: :any,                 monterey:       "4711e76f1cf788259eea9171fa196a229e332ebb706d27735d4796ce4bea8d43"
    sha256 cellar: :any,                 big_sur:        "bcd0f7f0f62c2ab101d3847132ccce9a3e4794aba5cebc25f3328b418c9cfdd6"
    sha256 cellar: :any,                 catalina:       "bf858d0c1f059f078c01dac277c6daebbfcd062ea45774948322b7fdf072f9f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d48dade506586e08e6e297e8c8c3c04dacb43a8b96381d50ea0360f4985bd54"
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
