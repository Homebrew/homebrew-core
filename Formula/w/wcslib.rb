class Wcslib < Formula
  desc "Library and utilities for the FITS World Coordinate System"
  homepage "https://www.atnf.csiro.au/computing/software/wcs/"
  url "https://www.atnf.csiro.au/computing/software/wcs/wcslib-releases/wcslib-8.10.tar.bz2"
  sha256 "447ecb7be9b43798f4d7f10855f3f39f826ad550bc9b330ced4736960fc65289"
  license "LGPL-3.0-or-later"
  compatibility_version 1

  livecheck do
    url :homepage
    regex(/href=.*?wcslib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "21a9a9505c067ae549847298646150718819a9a1ac798c77efa418dd980bbbfb"
    sha256 cellar: :any, arm64_tahoe:       "da68897509ba16a668255155c38c88e4e595420b6845903ab41985bbe4df997a"
    sha256 cellar: :any, arm64_sequoia:     "71e292d9ee8dafadfeb5a0f8ce0282c5d934541a7b81059f7b9a3673476b6759"
    sha256 cellar: :any, arm64_linux:       "678d2ba4e5676f437d6f0c7b07e5a67e865c8e31b8ae83fc42338897638f0856"
    sha256 cellar: :any, x86_64_linux:      "3865deea09614eb167cd626529aec653420a17779f9605aceb6cf09bf27675b4"
  end

  depends_on "cfitsio"

  deny_network_access!

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
