class Wcslib < Formula
  desc "Library and utilities for the FITS World Coordinate System"
  homepage "https://www.atnf.csiro.au/people/mcalabre/WCS/"
  url "https://www.atnf.csiro.au/pub/software/wcslib/wcslib-7.12.tar.bz2"
  sha256 "9cf8de50e109a97fa04511d4111e8d14bd0a44077132acf73e6cf0029fe96bd4"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?wcslib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "01aae3e82d7469c400573154e2cb724a8c0243ec91ee24dc3c6c0e1c45b948ba"
    sha256 cellar: :any,                 arm64_monterey: "f418a0c421237a184ea92462338644f6f60a3065815bed980118d13dfaacf45c"
    sha256 cellar: :any,                 arm64_big_sur:  "106c631c29a069fc17e4648807c308414765a88b838dac66fed25997d2265aa4"
    sha256 cellar: :any,                 ventura:        "fd5d489023f5a76af25221f504f1a122926fef40d3bd1a8aaf79519de37e512c"
    sha256 cellar: :any,                 monterey:       "eb4b9167d77c897c36d72e919976ae99da5793d8df33ff457c6d01efa6b2d739"
    sha256 cellar: :any,                 big_sur:        "989da78f103e6d0b9b0f933b688614f09a7809ee0a5fdbb5939c94b96556e5d8"
    sha256 cellar: :any,                 catalina:       "a7fee6167237f971ca2b474dbc774b8a4c72c50e402ff3dcd329841192c4bc19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f34302a5f97870b9a5db747c965a47fd17bef5545a6caf96bac06fa45d4c497b"
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
