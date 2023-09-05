class Wcslib < Formula
  desc "Library and utilities for the FITS World Coordinate System"
  homepage "https://www.atnf.csiro.au/people/mcalabre/WCS/"
  url "https://www.atnf.csiro.au/pub/software/wcslib/wcslib-8.1.tar.bz2"
  sha256 "2bf23e6fabd10b8aecffa54431bf25aa224ff019c60a9e676aa56561f9b4129e"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?wcslib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a10bdeef5a7a5707d0081de192bbb04ed185e14fa42004df792de7fe0fdc6e60"
    sha256 cellar: :any,                 arm64_monterey: "09f007e42a1ffb66b20af6878c7599a0e316a9eb708057d228173da2db076a10"
    sha256 cellar: :any,                 arm64_big_sur:  "7077b55049ed6e5f1e872a8feec72237f00c722fce347c8ff8e47cb82b916926"
    sha256 cellar: :any,                 ventura:        "23ed804a33bcb7cb354d4c46eae0cf522a003fe7ea132c22b619566dd4c99735"
    sha256 cellar: :any,                 monterey:       "688c5f712f7826711e1dbc83d7b21bf095822031afa90f291722c013652e5ad2"
    sha256 cellar: :any,                 big_sur:        "2bd1c58921f2cc3a3dc54057d6877e32c1780de2ec5c1edf214d2d640486dc3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ebbc048e32766835b474675cba45664aa4c827f0c09dab9690d8933a3b5af4d"
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
