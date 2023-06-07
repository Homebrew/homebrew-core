class Shtools < Formula
  desc "Spherical Harmonic Tools"
  homepage "https://shtools.github.io/SHTOOLS/"
  url "https://github.com/SHTOOLS/SHTOOLS/releases/download/v4.10.3/SHTOOLS-4.10.3.tar.gz"
  sha256 "ff630d6eeea73891c8c50bc73ad1c8539b7a0b5095449fbad1554493c4714d1e"
  license "BSD-3-Clause"
  head "https://github.com/SHTOOLS/SHTOOLS.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d4a9d6382303c5be51c4cb128603e10404ee516de50cc774774c82b030ee8df"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8fa8bc51fa29619664bf00d5e913fc679ef2f50eba4a2fff53661298f24d34c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ac52042aa6cf73fe61a5b1b95315c3b477e0e92bc0b58323597118df9dc51897"
    sha256 cellar: :any_skip_relocation, ventura:        "7cb43115fe58af4a9f8c6edceb45ca7433d5644c3f463c51fff26765697b36d6"
    sha256 cellar: :any_skip_relocation, monterey:       "c633ab38961cc7a5e23fae59eed6cb431c3406dec81d5d79960c597ac613d523"
    sha256 cellar: :any_skip_relocation, big_sur:        "99e3a3160bdcef39386b4bcffec851a61ae8ee344e57f91a6423acca8d1e9ca7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00f89161ac24d3da25c7267d61a41fa3c550df1296bce66b9b43b62c93d46ca8"
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
