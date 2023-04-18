class Shtools < Formula
  desc "Spherical Harmonic Tools"
  homepage "https://shtools.github.io/SHTOOLS/"
  url "https://github.com/SHTOOLS/SHTOOLS/releases/download/v4.10.1/SHTOOLS-4.10.1.tar.gz"
  sha256 "f4fb5c86841fe80136b520d2040149eafd4bc2d49da6b914d8a843b812f20b61"
  license "BSD-3-Clause"
  head "https://github.com/SHTOOLS/SHTOOLS.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7227085a1a3038518cbd30a4b53dd0fea5d43078cbe9168c870c673aaf03856b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "038729713c3013c2c06e453ea99ff52eb83f01adcd3bfd6435e1101054d4698f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "063c1e3013bf6dfc56ae3c0dbafe3214d52c3446b84f084accc2214838cd8d46"
    sha256 cellar: :any_skip_relocation, ventura:        "3b35f33e5756434a83142c56b5c0e6a2888c180d094ee3e9ad878665ee715be2"
    sha256 cellar: :any_skip_relocation, monterey:       "8164fa3de31c5909455ec628c680e35c051b0858fd643e0694b10debbd85d134"
    sha256 cellar: :any_skip_relocation, big_sur:        "170def5eead4a05b223b214bdff418edd84c62008687a246117362ea0e0f4cb3"
    sha256 cellar: :any_skip_relocation, catalina:       "e1e43ac26408f5592cc0b2140d18dee20048d91efb55782fe93389229fceba3c"
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
