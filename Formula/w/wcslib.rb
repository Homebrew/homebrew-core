class Wcslib < Formula
  desc "Library and utilities for the FITS World Coordinate System"
  homepage "https://www.atnf.csiro.au/people/mcalabre/WCS/"
  url "https://www.atnf.csiro.au/people/mcalabre/WCS/wcslib-8.2.2.tar.bz2"
  sha256 "6298220ae817f4e5522643ac4c3da2623be70a3484b1a4f37060bee3e4bd7833"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?wcslib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "9065acc4822b16649d3515c3512e8ef3de348db3880b6a2621c6ba40b40799a5"
    sha256 cellar: :any,                 arm64_sonoma:   "2857bd84c076a018a1f0e67c6b5d5a581cfb7bc41181286f70bd3d76bf611efa"
    sha256 cellar: :any,                 arm64_ventura:  "0a9273876cb5fc1be0e558bc831861250c047fe090430f759f3942059f8cbe30"
    sha256 cellar: :any,                 arm64_monterey: "36e9f26e57a04edf21666eb0d3d50051048b375af13a5dc23cf50d8e4d0d1c7a"
    sha256 cellar: :any,                 sonoma:         "c9097a8fd99d6c709a39a9b02eb194c49f2177112c977d1acc09623eb5e5723a"
    sha256 cellar: :any,                 ventura:        "5c50086dec7068ed77665b94fd069d442b5a37964504079cad4b447a5f789ef9"
    sha256 cellar: :any,                 monterey:       "e2988f3c63a643f9d2d1bd1a69cfe279084f22228fdecd725cda2022d4754496"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed4de50b36ab18e862f52c91aa0ab5c6087094d29d1cdea65bda3c6027eca854"
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
