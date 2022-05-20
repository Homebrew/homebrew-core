class Shtools < Formula
  desc "Spherical Harmonic Tools"
  homepage "https://shtools.github.io/SHTOOLS/"
  url "https://github.com/SHTOOLS/SHTOOLS/releases/download/v4.10/SHTOOLS-4.10.tar.gz"
  sha256 "03811abb576a1ebc697487256dc6e3d97ab9f88288efea8a2951d25613940dd1"
  license "BSD-3-Clause"
  head "https://github.com/SHTOOLS/SHTOOLS.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2fe638c34f0ec33f504a990ccab910339912a634330cbc0935a89a157feaf1ee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "57b9dc9c75b80fad0002b3e813d501ac12ea6f6f7e4bdad18c56dc03844a954b"
    sha256 cellar: :any_skip_relocation, monterey:       "3ef8010ed479290fa79b47aa891f3f8af18645c0d7bcc48f686e422be304ba99"
    sha256 cellar: :any_skip_relocation, big_sur:        "f15a2bb074aee900190a141b3115ada6c4bbb820112d9b518a6f3d3f0ce00677"
    sha256 cellar: :any_skip_relocation, catalina:       "f6a1f62c15469c160092763e470822f81bbc5d9138f3ed618f8887c64f70758b"
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
