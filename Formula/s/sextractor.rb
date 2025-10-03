class Sextractor < Formula
  desc "Extract catalogs of sources from astronomical images"
  homepage "https://www.astromatic.net/software/sextractor/"
  url "https://github.com/astromatic/sextractor/archive/refs/tags/2.28.2.tar.gz"
  sha256 "d92c5214ea75b8a70214d7d7f6824207fc53861ec923ceb2cc574f2ec9effa94"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "06bd29cd706f67f6b684f6cf2e4393e2977e0db250a242254c70ea95712358d4"
    sha256 arm64_sequoia: "114c7e6368360d1c5ef66850b1a2090bd84f759e323d320e0dd74549baed4714"
    sha256 arm64_sonoma:  "2138d679b5172a8f2b76d0fbacde1a67de054ccd9db6d3f5bcf5a163107f9098"
    sha256 arm64_ventura: "ca726287370efe2c960b98a02c8bcbe3b9a8491a584864d6333fd89a020a477d"
    sha256 sonoma:        "3a7f9a4b0880e0de0dca905679bea7e8747f3a299755f10a8437bd5432f65a30"
    sha256 ventura:       "9d53959e43245ab7d3ebac8bf8696d42c56a512bcc89672670c9f358fbbb6586"
    sha256 arm64_linux:   "eabbbb4573111bd7b50bf6fb15b0fa73a03146276d22d752c6a338f506a2f412"
    sha256 x86_64_linux:  "6b0fd897f186d16e044a010354109fbf0fd4b7ba4afddc4b7715cca6e741186e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "cfitsio"
  depends_on "fftw"
  depends_on "openblas"

  def install
    openblas = Formula["openblas"]
    # Allow OpenBLAS header migration to subdirectory. Can remove once done
    openblas_incdir = openblas.include/"openblas"
    openblas_incdir = openblas.include unless openblas_incdir.exist?

    system "./autogen.sh"
    system "./configure", "--disable-silent-rules",
                          "--enable-openblas",
                          "--with-openblas-libdir=#{openblas.lib}",
                          "--with-openblas-incdir=#{openblas_incdir}",
                          *std_configure_args
    system "make", "install"
    # Remove references to Homebrew shims
    rm Dir["tests/Makefile*"]
    pkgshare.install "tests"
  end

  test do
    cp_r Dir[pkgshare/"tests/*"], testpath
    system bin/"sex", "galaxies.fits", "-WEIGHT_IMAGE", "galaxies.weight.fits", "-CATALOG_NAME", "galaxies.cat"
    assert_path_exists testpath/"galaxies.cat", "Failed to create galaxies.cat"
  end
end
