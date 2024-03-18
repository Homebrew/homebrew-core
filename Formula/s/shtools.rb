class Shtools < Formula
  desc "Spherical Harmonic Tools"
  homepage "https://shtools.github.io/SHTOOLS/"
  url "https://github.com/SHTOOLS/SHTOOLS/archive/refs/tags/v4.12.2.tar.gz"
  sha256 "dcbc9f3258e958e3c8a867ecfef3913ce62068e0fa6eca7eaf1ee9b49f91c704"
  license "BSD-3-Clause"
  head "https://github.com/SHTOOLS/SHTOOLS.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b1680f060ecacd1501b699b42aefcb5185a316925298bf8309e8064c5f11036e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "474630875450960b7da6dba70172664558609a5a848577a1ac38c5993b788058"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a7d973f00e4749ce16dd754f570489183ed7623ecb07f9aadbd94d57819e764e"
    sha256 cellar: :any_skip_relocation, sonoma:         "f6ed69c843a88452a0b5a36845732bea2457f051309ad66643c7e49f803bbbea"
    sha256 cellar: :any_skip_relocation, ventura:        "851ec5c5a13bd37d3e9d460ce368656be61119a6acf618a33ab23aa78ef5c304"
    sha256 cellar: :any_skip_relocation, monterey:       "266187fe1e263156428432644610c4b45133127645ee18d41bd461d94ecc948e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebf6c8a5dbd76a0d8a93985c625bea278d633e9591b365196889db3430fbbd82"
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
