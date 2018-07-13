class Wcslib < Formula
  desc "Library and utilities for the FITS World Coordinate System"
  homepage "https://www.atnf.csiro.au/people/mcalabre/WCS/"
  url "ftp://ftp.atnf.csiro.au/pub/software/wcslib/wcslib-5.18.tar.bz2"
  sha256 "b693fbf14f2553507bc0c72bca531f23c59885be8f7d3c3cb889a5349129509a"
  revision 1

  bottle do
    cellar :any
    sha256 "54bbcd8e7f8208f42901a13a637fa2994f0fa9d33e4b3326aba4fc8f171504d4" => :sierra
    sha256 "209c69286e567c4cc34b6b70a0cf9f3beeb1182bb5a63e4ede05f684a0341771" => :el_capitan
    sha256 "04388c291155822d31637875b883a42d723a445aff90d6e25c9a267091cb312a" => :yosemite
  end

  option "with-pgplot", "Build PGSBOX, a general curvilinear axis drawing routine for PGPLOT"
  option "with-fortran", "Build Fortran wrappers. Needed for --with-pgsbox."
  option "with-test", "Perform `make check`. Note, together --with-pgsbox it will display GUI"

  deprecated_option "with-pgsbox" => "with-pgplot"
  deprecated_option "with-check" => "with-test"

  depends_on "cfitsio"
  depends_on "pgplot" => :optional
  depends_on :x11 if build.with? "pgplot"
  depends_on "gcc" if (build.with?("fortran") || build.with?("pgplot")) && OS.mac? # for gfortran

  def install
    args = ["--disable-debug",
            "--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--with-cfitsiolib=#{Formula["cfitsio"].opt_lib}",
            "--with-cfitsioinc=#{Formula["cfitsio"].opt_include}"]

    if build.with? "pgplot"
      args << "--with-pgplotlib=#{Formula["pgplot"].opt_lib}"
      args << "--with-pgplotinc=#{Formula["pgplot"].opt_include}"
    else
      args << "--without-pgplot"
      args << "--disable-fortran" if build.without? "fortran"
    end

    system "./configure", *args

    ENV.deparallelize
    system "make"
    system "make", "check" if build.with? "check"
    system "make", "install"
  end
end
