class Shtools < Formula
  desc "Spherical Harmonic Tools"
  homepage "https://shtools.github.io/SHTOOLS/"
  url "https://github.com/SHTOOLS/SHTOOLS/archive/refs/tags/v4.12.2.tar.gz"
  sha256 "dcbc9f3258e958e3c8a867ecfef3913ce62068e0fa6eca7eaf1ee9b49f91c704"
  license "BSD-3-Clause"
  head "https://github.com/SHTOOLS/SHTOOLS.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7d139c07337891fe153bbf18700cb4d45f258177f9a3c8f4cbc4f54cadce446a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68a1fd186978e7993f4656eac8b2df6f9076e8d4e42565ca67d754aaad9cc7d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7bf7cbe3cd3ca8e4c7a25f668dc709c26a20b6166e7149aaa34607d6420b4a5f"
    sha256 cellar: :any_skip_relocation, sonoma:         "ff84c07de9706cbb77e8c7c058c383eb6382edf9bfc5a683ed6ab49eb4e0a566"
    sha256 cellar: :any_skip_relocation, ventura:        "d8bc6890a51dfce4f141ea650f9635fd47982bbee0352a9e1742b74796ab5fda"
    sha256 cellar: :any_skip_relocation, monterey:       "b4575c4027ef6086e68e3c14be1bf6577b8f494e7638af3a9e6a29b29fdb9053"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46e390c6a35f4e23ec07a96421758cd9729ee2c0f14118fcc79006f291bf64e2"
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
