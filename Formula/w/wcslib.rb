class Wcslib < Formula
  desc "Library and utilities for the FITS World Coordinate System"
  homepage "https://www.atnf.csiro.au/computing/software/wcs/"
  url "https://www.atnf.csiro.au/computing/software/wcs/wcslib-releases/wcslib-8.6.tar.bz2"
  sha256 "e030423605a199ef090fe742bc901a82d9e6b3a77e010e211cdd6d2cd067cd5a"
  license "LGPL-3.0-or-later"
  compatibility_version 1

  livecheck do
    url :homepage
    regex(/href=.*?wcslib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b943bc6a0229936ed5aa83cb6775b7ca7d8dac1b3472f749bf223be821b80c2b"
    sha256 cellar: :any,                 arm64_sequoia: "ee32abe3a83329fef3bb0c87ad03aa3da39c74a5191607da28bd82bef8f3094a"
    sha256 cellar: :any,                 arm64_sonoma:  "c622f56463100e34008836ebc5bb31136f925663754c55bd8f247abcb38826c6"
    sha256 cellar: :any,                 sonoma:        "bcf3fe6b366e895248cd5873f5ea5345a6cc112e7f06773816badf96de3147ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb4be28b827d90f66d50d02f4a31c96468b3571a6ae890daa1eeff8fd8fd5833"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ef214cebb093d3b4165e7a9fd27a2938839379ab4d30fb74d56a1272852da0d"
  end

  depends_on "cfitsio"

  def install
    # Remove all the revision control files which mention prior GPL license
    # to avoids accidentally compiling GPL code which would impact license.
    rm_r buildpath.glob("**/RCS/")

    system "./configure", "--disable-fortran",
                          "--with-cfitsiolib=#{Formula["cfitsio"].opt_lib}",
                          "--with-cfitsioinc=#{Formula["cfitsio"].opt_include}",
                          "--without-pgplot",
                          *std_configure_args
    system "make", "install"
  end

  test do
    piped = "SIMPLE  =" + (" "*20) + "T / comment" + (" "*40) + "END" + (" "*2797)
    pipe_output("#{bin}/fitshdr", piped, 0)
  end
end
