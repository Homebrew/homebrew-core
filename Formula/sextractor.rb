class Sextractor < Formula
  desc "Extract catalogs of sources from astronomical images"
  homepage "https://github.com/astromatic/sextractor"
  url "https://github.com/astromatic/sextractor/archive/refs/tags/2.25.0.tar.gz"
  sha256 "ab8ec8fe2d5622a94eb3a20d007e0c54bf2cdc04b8d632667b2e951c02819d8e"
  license "GPL-3.0-or-later"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "fftw"
  depends_on "openblas"

  def install
    openblas = Formula["openblas"]
    system "./autogen.sh"
    system "./configure", *std_configure_args,
           "--disable-silent-rules",
           "--enable-openblas",
           "--with-openblas-libdir=#{openblas.lib}",
           "--with-openblas-incdir=#{openblas.include}"
    system "make", "install"
    # Remove references to Homebrew shims
    rm Dir["tests/Makefile*"]
    pkgshare.install "tests"
  end

  test do
    cp_r Dir[pkgshare/"tests/*"], testpath
    system "#{bin}/sex", "galaxies.fits", "-WEIGHT_IMAGE", "galaxies.weight.fits", "-CATALOG_NAME", "galaxies.cat"
    assert_predicate testpath/"galaxies.cat", :exist?, "Failed to create galaxies.cat"
  end
end
