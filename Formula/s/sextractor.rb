class Sextractor < Formula
  desc "Extract catalogs of sources from astronomical images"
  homepage "https://www.astromatic.net/software/sextractor/"
  url "https://github.com/astromatic/sextractor/archive/refs/tags/2.29.0.tar.gz"
  sha256 "f260886b1609f3a3dbe82ea14152761ed0434bc37631be4121137fee36025111"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_golden_gate: "adc8b556f0810147755dd603f1ba7cf8b408f47341e040085f380e5414adb516"
    sha256 arm64_tahoe:       "a4115da37455083592b0e177730dc18a318f01414048f4236a41f700357fccc8"
    sha256 arm64_sequoia:     "0569170fda55206ac2196500f6935a6a5a5104f7c36d5214699af3e7da278bb4"
    sha256 arm64_linux:       "9a17279567d154d5f537d9f11cd799f52be4d4a7a0ab68401aa743468a8d271b"
    sha256 x86_64_linux:      "07c5be9f8e0acb8444bb4e471583c1903d4b670f04e58f59a8f9136d1791d6f6"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "cfitsio"
  depends_on "fftw"
  depends_on "openblas"

  def install
    # Allow OpenBLAS header migration to subdirectory. Can remove once done
    openblas_incdir = formula_opt_include("openblas")/"openblas"
    openblas_incdir = formula_opt_include("openblas") unless openblas_incdir.exist?

    system "./autogen.sh"
    system "./configure", "--disable-silent-rules",
                          "--enable-openblas",
                          "--with-openblas-libdir=#{formula_opt_lib("openblas")}",
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
