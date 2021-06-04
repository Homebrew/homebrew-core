class Shtools < Formula
  desc "Spherical Harmonic Tools"
  homepage "https://shtools.github.io/SHTOOLS/"
  url "https://github.com/SHTOOLS/SHTOOLS/releases/download/v4.8/SHTOOLS-4.8.tar.gz"
  sha256 "c36fc86810017e544abbfb12f8ddf6f101a1ac8b89856a76d7d9801ffc8dac44"
  license "BSD-3-Clause"
  head "https://github.com/SHTOOLS/SHTOOLS.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "1a9fd37585d31ef6f1c61b431bfab4fde9755db5ee081d8eba1c9a358278481f"
    sha256 cellar: :any_skip_relocation, catalina: "99aea0397bae82f956eab6868704b493b99f9160e4c5f8f558937db3e349b96b"
    sha256 cellar: :any_skip_relocation, mojave:   "00f6302f52c6df51ee3477d0c05d66c1a1feec59a4b8883b2af53faa6a631e30"
  end

  depends_on "fftw"
  depends_on "gcc"
  depends_on "openblas"

  def install
    system "make", "fortran"
    system "make", "fortran-mp"

    pkgshare.install "examples/fortran/", "examples/ExampleDataFiles/"

    lib.install "lib/libSHTOOLS.a", "lib/libSHTOOLS-mp.a"
    include.install "include/fftw3.mod",
                    "include/planetsconstants.mod",
                    "include/shtools.mod",
                    "include/ftypes.mod",
                    "include/shtools.h"
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
