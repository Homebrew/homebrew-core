class Shtools < Formula
  desc "Spherical Harmonic Tools"
  homepage "https://shtools.github.io/SHTOOLS/"
  url "https://github.com/SHTOOLS/SHTOOLS/archive/refs/tags/v4.13.1.tar.gz"
  sha256 "d5890049fb915604f25576cbbb9f18980a3fc88d28fe380809e3c3497448dacb"
  license "BSD-3-Clause"
  head "https://github.com/SHTOOLS/SHTOOLS.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "12ba765ca24a4050e53ad4e7f6c8bb718229f678292267b821113000aa037045"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "59ee77323ec5349e2ec3220bbb5addd94e5d8c61c51ed83f542e1c5b76e1b5da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3f4c42204d7918ac1ed66e651c9e44c5b3909d534be6173e9a3034cc78c6f288"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0c8d580e0e29de7926ee296d259decafb3dfcc240dbc35e66dfdad22f1cc6552"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "96ee5658d7de4f1f1299929773c29178033c9417f4c3976f192ba766ff2b4ce3"
    sha256 cellar: :any_skip_relocation, sonoma:         "5a5d2f8bd23c91d1108f19d9180df102f7ebac81faf440c4c1e6ded69b7c13f9"
    sha256 cellar: :any_skip_relocation, ventura:        "acebb261a0ceef034d6f243b3b146d29a4ed67de632b8f815b892fa9e276bde8"
    sha256 cellar: :any_skip_relocation, monterey:       "3015528ef552810ad555a4d935b19961efe058ceb057995a42e2e36b59207352"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "8539b8bc1f073942972d36dc4488ddd549d00f2568e965be281e3183eaa74fec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d943e8846fb394abe3b7689588fa59adc91b6ed0b56cf7ce67df70d09a650aa"
  end

  depends_on "fftw"
  depends_on "gcc"
  depends_on "openblas"

  on_linux do
    depends_on "libtool" => :build
  end

  def install
    # Workaround for arm64 linux, https://github.com/SHTOOLS/SHTOOLS/issues/507
    inreplace "Makefile", " -m64 ", " " if OS.linux? && Hardware::CPU.arm?

    system "make", "fortran"
    system "make", "fortran-mp"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    cp_r "#{share}/examples/shtools", testpath
    m64 = "-m64" if Hardware::CPU.intel?
    system "make", "-C", "shtools/fortran",
                   "run-fortran-tests-no-timing",
                   "F95=gfortran",
                   "F95FLAGS=#{m64} -fPIC -O3 -std=gnu -ffast-math",
                   "MODFLAG=-I#{HOMEBREW_PREFIX}/include",
                   "LIBPATH=#{HOMEBREW_PREFIX}/lib",
                   "LIBNAME=SHTOOLS",
                   "FFTW=-L #{HOMEBREW_PREFIX}/lib -lfftw3 -lm",
                   "LAPACK=-L #{Formula["openblas"].opt_lib} -lopenblas",
                   "BLAS="
  end
end
