class Shtools < Formula
  desc "Spherical Harmonic Tools"
  homepage "https://shtools.github.io/SHTOOLS/"
  url "https://github.com/SHTOOLS/SHTOOLS/releases/download/v4.9.1/SHTOOLS-4.9.1.tar.gz"
  sha256 "5c22064f9daf6e9aa08cace182146993aa6b25a6ea593d92572c59f4013d53c2"
  license "BSD-3-Clause"
  head "https://github.com/SHTOOLS/SHTOOLS.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fc51eae35bb14ae633451c030eadac4f4460e706aa00fb4510c943a15d555baf"
    sha256 cellar: :any_skip_relocation, monterey:      "15aeebdacaa7cf5a698ac7eb60c82de648fdc648f32c7633a417896bf20e030c"
    sha256 cellar: :any_skip_relocation, big_sur:       "967d6cf5bc8da7bb1f35733425670790ef7241bd21dc31bddbb1b0dd4e0d7c72"
    sha256 cellar: :any_skip_relocation, catalina:      "143f85cefb75fc760b2cedde24fa2ca51f18503f48cac8391f02f9b2f1dcf3dd"
    sha256 cellar: :any_skip_relocation, mojave:        "ef58dfe8056ba34bc5aff640a23e374e59bd969949c06262cd16580c9e2ca1c4"
  end

  depends_on "fftw"
  depends_on "gcc"
  depends_on "openblas"

  def install
    system "make", "fortran"
    system "make", "fortran-mp"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    cp_r "#{share}/examples/shtools", testpath
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
