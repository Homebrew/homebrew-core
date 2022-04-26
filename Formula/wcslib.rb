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
    sha256 cellar: :any,                 arm64_monterey: "7201671c6a32549d357a616926be707e2e578d86fe6a491d368ae603f4dd726f"
    sha256 cellar: :any,                 arm64_big_sur:  "221cc7e8d8872400912339897cd01454ea5597c45cad9c9a380f5aa015a140ff"
    sha256 cellar: :any,                 monterey:       "b1771728f18d06004a29d45f511a6f45beca469e3138392eec818c7f7fe58de9"
    sha256 cellar: :any,                 big_sur:        "3a83285077a761232eef2acbc4cacdadde4126c770724f35b3eb91cf51d8022f"
    sha256 cellar: :any,                 catalina:       "6754297d561baf8393433faceab38bd75df3eb01214c0b3affe10032c3755b2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "672880fb76adb3d8d5e927913a0062b41a781df96e97437e32ba1da552b2a852"
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
