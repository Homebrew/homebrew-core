class Wcslib < Formula
  desc "Library and utilities for the FITS World Coordinate System"
  homepage "https://www.atnf.csiro.au/computing/software/wcs/"
  url "https://www.atnf.csiro.au/computing/software/wcs/wcslib-releases/wcslib-8.7.tar.bz2"
  sha256 "792fe05c09544433a9a4ea5480facdbec2da6d28058275b5e9006a1f28c56465"
  license "LGPL-3.0-or-later"
  compatibility_version 1

  livecheck do
    url :homepage
    regex(/href=.*?wcslib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7862b82a3edb40c92b1db6bd17d33b150ff46b3354a6072dea7c53c4a21875d8"
    sha256 cellar: :any,                 arm64_sequoia: "80d43d74309563e70cb7e81d545b86a96ff6e3fe4e6e8ed74d92258e83586a74"
    sha256 cellar: :any,                 arm64_sonoma:  "dc562a7d28d614c06344dd69d1cd625125e21b674cc0cc1bb5a5d32f30e08912"
    sha256 cellar: :any,                 sonoma:        "3aee2b3fc19089b1a2e25619c2b8d120467960d54f987990c05a039b6057daec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a3e05e8f3590410d0d6dedce0e9a168f5e071c36814d489de4e558873bee325"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9448426b45eec907d0d711aafea4afe8ef1ed8de083e3f07f247ae8c3d38a79c"
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
