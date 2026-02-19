class Wcslib < Formula
  desc "Library and utilities for the FITS World Coordinate System"
  homepage "https://www.atnf.csiro.au/computing/software/wcs/"
  url "https://www.atnf.csiro.au/computing/software/wcs/wcslib-releases/wcslib-8.5.tar.bz2"
  sha256 "f1fd1b78fbfdbabda363f8045e0c59e32735eca45482a5302191e56fe062eace"
  license "LGPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?wcslib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7b176690e05aff3882cecc3e5c6ef64d800c2cb5ce5ebf8629c5b7908f8cca5f"
    sha256 cellar: :any,                 arm64_sequoia: "b254677bd8b4b7a06702079840332bb63ffc26a7858d50c8161192bbf618e9aa"
    sha256 cellar: :any,                 arm64_sonoma:  "eb929201b5228f879e57b117fc31b4d408dbe9d90c777bec07d899d8833803df"
    sha256 cellar: :any,                 sonoma:        "0a5a6f824d5bb42d811358b69df421eb1a50a45140241318103753ff2efb5cfc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e754f29a4470f5a89690a2147596d89df0bccaf0e3e4910567cf7f29123d96b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10cd6cb0fdd6857a41558bbb526d12d0666ac11c6e07262c41ce350d46393318"
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
