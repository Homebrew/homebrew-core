class Wcslib < Formula
  desc "Library and utilities for the FITS World Coordinate System"
  homepage "https://www.atnf.csiro.au/people/mcalabre/WCS/"
  url "https://www.atnf.csiro.au/pub/software/wcslib/wcslib-7.12.tar.bz2"
  sha256 "9cf8de50e109a97fa04511d4111e8d14bd0a44077132acf73e6cf0029fe96bd4"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?wcslib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cf56e8f00d910a9504e52dcd663a679a304fcfffb3476229fc4fae47b3ee58ad"
    sha256 cellar: :any,                 arm64_monterey: "5a0e1c9316e9c87d0d138cb95548d3533de9b565ff898528209808834279a639"
    sha256 cellar: :any,                 arm64_big_sur:  "4a9043503641f0ea77dbfd50e0ca2281313302d0e0ad8a382bf44eb7e5fb8dd4"
    sha256 cellar: :any,                 ventura:        "50f4ece595a1fb84b2de9a3f50cfc79aba7022ebe61bdbe2f1da78db6b4f25a5"
    sha256 cellar: :any,                 monterey:       "fa7daa0fe9e470fd6e018cd5693e75c1027a1101968e248f82d4ea78ac90a41d"
    sha256 cellar: :any,                 big_sur:        "48ea25010a8e8f6f5463066b6b7853de13b956c807a0e02ab5f95cb9549ec547"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "306df7e5bcde3578745801d8b4bcf7b9c6028b6c978dd8702501df0716957a13"
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
