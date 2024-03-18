class Shtools < Formula
  desc "Spherical Harmonic Tools"
  homepage "https://shtools.github.io/SHTOOLS/"
  url "https://github.com/SHTOOLS/SHTOOLS/archive/refs/tags/v4.12.1.tar.gz"
  sha256 "4e9bb72f44b83ccd5bee141b6ff6e6f87eecd259bfb63464f0c2bef4f8b88e48"
  license "BSD-3-Clause"
  head "https://github.com/SHTOOLS/SHTOOLS.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "426a2b8a4ed608f76f9c5bc438c53a498549e04f3a1d8c8f3fa357d5787ea88b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e8e47113dbb8208b7e348a11b27659490a3524f229c516a02adeb4e6011fc220"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad9126e93757f33ae5cad1612a9a09539ccaeb705e8fac9f6bceb18b10a47a48"
    sha256 cellar: :any_skip_relocation, sonoma:         "17393fb9829fd2c8ce7517c41a8e94faa97cd572610abb8d0d1223bf416211b7"
    sha256 cellar: :any_skip_relocation, ventura:        "06659c9e2bd5b2c66c4a1675b392cd5403e04ccbf75b264b66f69697eb06d21c"
    sha256 cellar: :any_skip_relocation, monterey:       "f8fe64cd2c915ebe42cdddd933f4a59d4e51e3c7caf953cda5bc0667d5487c04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13a462c4536a970655f5df3189c00e786e220f399c73762c723838ef7adf69d1"
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
