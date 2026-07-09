class Wcslib < Formula
  desc "Library and utilities for the FITS World Coordinate System"
  homepage "https://www.atnf.csiro.au/computing/software/wcs/"
  url "https://www.atnf.csiro.au/computing/software/wcs/wcslib-releases/wcslib-8.9.tar.bz2"
  sha256 "82ac09ce5091b0bf06cec8f5cdeec1dabe1d06ba5dfb7ff2bdb0c1680488807b"
  license "LGPL-3.0-or-later"
  compatibility_version 1

  livecheck do
    url :homepage
    regex(/href=.*?wcslib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6c4d405f732b645d6a510a09f818c58cb5c2420d01165cfa9eda29e65fc59baf"
    sha256 cellar: :any, arm64_sequoia: "7df83c4265c328c65f82e634ab3eebeb7f4b8f82b6d256c8f307e1b9ec1cb9cc"
    sha256 cellar: :any, arm64_sonoma:  "0203ae796a2bed7337e97124bb2cd6323de06d98d6bc9d60069facb2b96c3ff3"
    sha256 cellar: :any, sonoma:        "692d43d16d2f50ee948bb505e26258eca12f344969e34de1f559cf8d9258d728"
    sha256 cellar: :any, arm64_linux:   "8bce64540ba8e45e079cd7fcc745d00bc91f9c6852db212a148662566481cc93"
    sha256 cellar: :any, x86_64_linux:  "fb82f332c5340b5927f1c9d3c2dcb32ac74919239d676620113321fe394c03a4"
  end

  depends_on "cfitsio"

  def install
    # Remove all the revision control files which mention prior GPL license
    # to avoids accidentally compiling GPL code which would impact license.
    rm_r buildpath.glob("**/RCS/")

    system "./configure", "--disable-fortran",
                          "--with-cfitsiolib=#{formula_opt_lib("cfitsio")}",
                          "--with-cfitsioinc=#{formula_opt_include("cfitsio")}",
                          "--without-pgplot",
                          *std_configure_args
    system "make", "install"
  end

  test do
    piped = "SIMPLE  =" + (" "*20) + "T / comment" + (" "*40) + "END" + (" "*2797)
    pipe_output("#{bin}/fitshdr", piped, 0)
  end
end
