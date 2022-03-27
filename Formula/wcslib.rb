class Wcslib < Formula
  desc "Library and utilities for the FITS World Coordinate System"
  homepage "https://www.atnf.csiro.au/people/mcalabre/WCS/"
  url "https://www.atnf.csiro.au/pub/software/wcslib/wcslib-7.9.tar.bz2"
  sha256 "beff8c1f0e8600078813c032d1afcd9cb305c31f567567434824233d582aba58"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?wcslib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "31883ae8cbdfe7fef884b78c70c5bee9a3cd7fdbeb8595e0dd4dfc55c5df65aa"
    sha256 cellar: :any,                 arm64_big_sur:  "b5c399159bdb649af8473d0bbff2719d67ca3bfdc9333c7f793d555254649364"
    sha256 cellar: :any,                 monterey:       "96de43cfcba8574071dfdf55da0873b2b46ec925a3dca3f270eddffcf3f3f1b4"
    sha256 cellar: :any,                 big_sur:        "d1c9a78ec527f051ea75c139da1531ab273ea536fe7968fba816f7461ad4c821"
    sha256 cellar: :any,                 catalina:       "575a06b0f80ed5289859f3e064f27411ed1d525ba890b2f2db1f03ee066274f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df52267dfba060f5fe8823275235e5cacc7f9834fb2be32cc336f690c56c44a0"
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
