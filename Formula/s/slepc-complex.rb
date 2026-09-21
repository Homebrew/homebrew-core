class SlepcComplex < Formula
  desc "Scalable Library for Eigenvalue Problem Computations (complex)"
  homepage "https://slepc.upv.es"
  url "https://slepc.upv.es/download/distrib/slepc-3.25.2.tar.gz"
  sha256 "65795612fd50efd77d151bb884b0075429fe12c532963e38081988a5ed6efbd5"
  license "BSD-2-Clause"

  livecheck do
    formula "slepc"
  end

  bottle do
    sha256 arm64_golden_gate: "ec90423983d0d0eb291ba3d5f3d04fa3781bdbb4ec08e6b9920a3db4f3c37e67"
    sha256 arm64_tahoe:       "520abb94eeea46a08f95fdad1e410c8e73458f55a7c5feeb642709e66cc455cf"
    sha256 arm64_sequoia:     "49323007004f67f00f5f2216b05280dc9c7c817fc399a359717f0f4f930a1c2c"
    sha256 arm64_linux:       "594305dbe1acab1e53c53eb9ce12c5a21bd50c7049ec6532ab7b4e837fbd07ab"
    sha256 x86_64_linux:      "b1df053a4f1bff55bbdcf2192bfee5522960b48cdf7c40f22097fcd1b52439ae"
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
    flags = %W[-I#{include} -L#{lib} -lslepc -I#{formula_opt_include(pform)} -L#{formula_opt_lib(pform)} -lpetsc]
    flags << "-Wl,-rpath,#{lib},-rpath,#{formula_opt_lib(pform)}" if OS.linux?
    system "mpicc", pkgshare/"../slepc/examples/src/eps/tutorials/ex2.c", "-o", "test", *flags
    output = shell_output("./test -terse")
    # This SLEPc example prints several lines of output. The 7th line contains
    # a specific message if everything went well
    line = output.lines.at(-3)
    assert_match "All requested eigenvalues computed up to the required tolerance:", line
  end
end
