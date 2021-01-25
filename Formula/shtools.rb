class Shtools < Formula
  desc "Spherical Harmonic Tools"
  homepage "https://shtools.github.io/SHTOOLS/"
  url "https://github.com/SHTOOLS/SHTOOLS/archive/v4.7.1.tar.gz"
  sha256 "6ed2130eed7b741df3b19052b29b3324601403581c7b9afb015e0370e299a2bd"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/SHTOOLS/homebrew-shtools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5c5163cc734b57d538fc8507a974fbafa7fd52769ff3d51f18f69bef8a399b18" => :big_sur
    sha256 "02042f2cf73c441cc6f0a98654ededcaccefe1851d7817bdb7dde72d6f7a8af4" => :catalina
    sha256 "b8f08723ebb0811022c50a8e86cab9a9844427859ddc708660c7d5375825983b" => :mojave
    sha256 "e96a79e0e15a37acd2758c10c2b3d3bb7a98d5372f8fb856205a1a8b10a4891f" => :high_sierra
  end

  depends_on "fftw"
  depends_on "gcc"
  depends_on "openblas"

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
                   "LAPACK=-L #{Formula["openblas"].opt_lib} -lopenblas",
                   "BLAS="
  end
end
