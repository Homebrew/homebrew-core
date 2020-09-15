class Shtools < Formula
  desc "Spherical Harmonic Tools"
  homepage "https://shtools.github.io/SHTOOLS/"
  url "https://github.com/SHTOOLS/SHTOOLS/archive/v4.7.1.tar.gz"
  sha256 "6ed2130eed7b741df3b19052b29b3324601403581c7b9afb015e0370e299a2bd"
  license "BSD-3-Clause"
  head "https://github.com/SHTOOLS/homebrew-shtools.git"

  depends_on "fftw"
  depends_on "gcc"

  def install
    system "make", "fortran"
    system "make", "fortran-mp"

    pkgshare.install "examples/fortran/", "examples/ExampleDataFiles/"

    lib.install "lib/libSHTOOLS.a", "lib/libSHTOOLS-mp.a"
    include.install "include/fftw3.mod", "include/planetsconstants.mod", "include/shtools.mod", "include/ftypes.mod"
    share.install "man"
  end

  test do
    cp_r pkgshare, testpath
    system "make", "-C", "shtools/fortran",
                   "run-fortran-tests-no-timing",
                   "F95=gfortran",
                   "F95FLAGS=-m64 -fPIC -O3 -std=gnu -ffast-math",
                   "MODFLAG=-I#{HOMEBREW_PREFIX}/include",
                   "LIBPATH=#{HOMEBREW_PREFIX}/lib",
                   "LIBNAME=SHTOOLS",
                   "FFTW=-L #{HOMEBREW_PREFIX}/lib -lfftw3 -lm",
                   "LAPACK=-framework accelerate",
                   "BLAS="
  end
end
