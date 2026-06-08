class Wcslib < Formula
  desc "Library and utilities for the FITS World Coordinate System"
  homepage "https://www.atnf.csiro.au/computing/software/wcs/"
  url "https://www.atnf.csiro.au/computing/software/wcs/wcslib-releases/wcslib-8.8.tar.bz2"
  sha256 "dcd5b952e68016d0e2459e1f0f9866343e78b939635db64429fcf478e1ea4bfc"
  license "LGPL-3.0-or-later"
  compatibility_version 1

  livecheck do
    url :homepage
    regex(/href=.*?wcslib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "32af7b69d67e10611976c037cb15da8b2d0be1b5ea9c38ae428e2ef81f1f3721"
    sha256 cellar: :any,                 arm64_sequoia: "08444a8aeebb67b87578fea1d5832b0035327f509c9cdbc419c37c449af694ac"
    sha256 cellar: :any,                 arm64_sonoma:  "817e9784586d45b9b7ff021d2931e6b154cf059d38666a5b122d6761680ef550"
    sha256 cellar: :any,                 sonoma:        "92216f4d05f77b604d842bb0b06d0218cedbbcc8e1e8b087f542f3a1a1396506"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b7528a640dcc0e6f8e0a105a6b1b404fc0ed2449a2c10398846a5096612929c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3a8f06e621d144e25e8e0c96c9a01ad3fbfc3d5540bee4a0aae4d54f9505365"
  end

  depends_on "cfitsio"

  def install
    # Remove all the revision control files which mention prior GPL license
    # to avoids accidentally compiling GPL code which would impact license.
    rm_r buildpath.glob("**/RCS/")

    # Expose C99 snprintf() in flex-generated sources.
    inreplace "configure", "-D_POSIX_C_SOURCE=1", "-D_POSIX_C_SOURCE=200112L"

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
