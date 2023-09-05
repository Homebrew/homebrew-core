class Shtools < Formula
  desc "Spherical Harmonic Tools"
  homepage "https://shtools.github.io/SHTOOLS/"
  url "https://github.com/SHTOOLS/SHTOOLS/releases/download/v4.10.4/SHTOOLS-4.10.4.tar.gz"
  sha256 "f31ab09e960d85ad23d046fa427b692ffb80915a2c96773725bb83ad90bdec20"
  license "BSD-3-Clause"
  head "https://github.com/SHTOOLS/SHTOOLS.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4d516fee552a00a9ee794b7c490354e249df71c139e10b18a8c98f1e63977296"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3041130dbfb04cb18c21d6666e367fc5aec833be4d8d58d566f368a92ce9bf43"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4c2d62f87979d7ba8e5a2225346e5a29f08b4949850595cc35b40b16e3ad1fa5"
    sha256 cellar: :any_skip_relocation, ventura:        "d954b3cfc364762d426be63f215abe53f67e98f949410f15f20f46bbcc973c18"
    sha256 cellar: :any_skip_relocation, monterey:       "83cab587a3b98a1553b4122cb6f5091b8e1ede7885f93b6d364c72baded57f55"
    sha256 cellar: :any_skip_relocation, big_sur:        "17f1f6d84a125a4be262219979b833639ed9d9eeadb7c9128d02dc2424fb1b37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "849384f63da7846b6894e0b2dd44538f66f5da43d60e6baa7afb137a67b829cf"
  end

  depends_on "fftw"
  depends_on "gcc"
  depends_on "openblas"

  on_linux do
    depends_on "libtool" => :build
  end

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
