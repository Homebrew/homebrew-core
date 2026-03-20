class Shtools < Formula
  desc "Spherical Harmonic Tools"
  homepage "https://shtools.github.io/SHTOOLS/"
  url "https://github.com/SHTOOLS/SHTOOLS/archive/refs/tags/v4.14.1.tar.gz"
  sha256 "df2085e1408b078009a798db0c7eb13b56968853d8b86e1a963695fcb985bef7"
  license "BSD-3-Clause"
  head "https://github.com/SHTOOLS/SHTOOLS.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "551f3742a534b688159c5b556212ff3af70f28358077e979597a0cc35389cbe1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1e1742e0512c760952f2524594ab1e93ae1de75412748d714d2bbfb96ed2821"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd0d30386519cb74fc6dadbe048e34066f6d86367d93724a7729e5cd22a43419"
    sha256 cellar: :any_skip_relocation, sonoma:        "9577ab0f56e7437427b62f14c349c426ef5175fcc863c15abce72ef3fb842c6f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9a8be3b4650a68496fef0e3a6b720ac3cc31bc74e1bb0c226382591a6866703"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "051f326f89c54321931c050881900955cfb9098004a554ad10921d34325b3a20"
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
