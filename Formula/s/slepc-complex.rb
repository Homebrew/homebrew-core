class SlepcComplex < Formula
  desc "Scalable Library for Eigenvalue Problem Computations (complex)"
  homepage "https://slepc.upv.es"
  url "https://slepc.upv.es/download/distrib/slepc-3.24.2.tar.gz"
  sha256 "6f1f7e45b9bbd15631562f193284832ae4e9655eb3af7f1ba59bdf8bdaefb638"
  license "BSD-2-Clause"
  revision 1

  livecheck do
    formula "slepc"
  end

  bottle do
    sha256 arm64_tahoe:   "0ee41fed06f6b2e13da19287ae9d84f33dceb875619a42e141e3cf0320a96792"
    sha256 arm64_sequoia: "bec90525830fee8e73558025a9e3babe097058f25d9fe7310bb25f56398836ce"
    sha256 arm64_sonoma:  "dc0f20f37361117ede47e9c0d826f96ceb4905d0f010ffb61deecdc00cdfcaa8"
    sha256 sonoma:        "c4e384ba2d616ff7209a7272b3aeaa3a5689e48b63e6fa469fb38c630981ad83"
    sha256 arm64_linux:   "19cc65f5b7a14207e95817c09cbb90272f90e513ce7cb8aba553f3511a494cc8"
    sha256 x86_64_linux:  "bce927791f699727b7a95cc1f5952427e9e7cb26603ca87ab8b16f5a22022aa1"
  end

  depends_on "open-mpi"
  depends_on "openblas"
  depends_on "petsc-complex"
  depends_on "scalapack"

  uses_from_macos "python" => :build

  on_macos do
    depends_on "fftw"
    depends_on "gcc"
    depends_on "hdf5-mpi"
    depends_on "metis"
  end

  conflicts_with "slepc", because: "slepc must be installed with either real or complex support, not both"

  def install
    ENV["PETSC_DIR"] = Formula["petsc-complex"].prefix.realpath
    ENV["SLEPC_DIR"] = buildpath

    # This is not an autoconf script so cannot use `std_configure_args`
    system "./configure", "--prefix=#{prefix}"
    system "make", "all"
    system "make", "install", "PYTHON=#{which("python3")}"
  end

  test do
    pform = "petsc-complex"
    flags = %W[-I#{include} -L#{lib} -lslepc -I#{Formula[pform].include} -L#{Formula[pform].lib} -lpetsc]
    flags << "-Wl,-rpath,#{lib},-rpath,#{Formula[pform].lib}" if OS.linux?
    system "mpicc", pkgshare/"../slepc/examples/src/eps/tutorials/ex2.c", "-o", "test", *flags
    output = shell_output("./test -terse")
    # This SLEPc example prints several lines of output. The 7th line contains
    # a specific message if everything went well
    line = output.lines.at(-3)
    assert_match "All requested eigenvalues computed up to the required tolerance:", line
  end
end
