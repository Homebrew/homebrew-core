class SlepcComplex < Formula
  desc "Scalable Library for Eigenvalue Problem Computations (complex)"
  homepage "https://slepc.upv.es"
  url "https://slepc.upv.es/download/distrib/slepc-3.25.1.tar.gz"
  sha256 "906ddbe15a20774c23ddcdf13a5054889d00a26c3c37463447ee593c757d03ee"
  license "BSD-2-Clause"

  livecheck do
    formula "slepc"
  end

  bottle do
    sha256 arm64_tahoe:   "de1a0d597d6d9867024781f8d5990bd82ebc34dbf1c394a95d3fd2c0996c5d97"
    sha256 arm64_sequoia: "25381b6aa0fcfec55713f8e4771add1dd72b853196ee18e9f823ac55d744eb88"
    sha256 arm64_sonoma:  "05063a6b83b50453c48b1b8a30ea09d9bd31732214ffa891ca047dec78fe9b17"
    sha256 sonoma:        "7f6ca31f531c31fccf186442e012cc88f4820dc3b8d82fb0edfa0a7d73c21981"
    sha256 arm64_linux:   "f4c3ebfa585a1e29ccf238625a69088eafd40397c8cdb8aa2a4b6b69bad83c6c"
    sha256 x86_64_linux:  "ccf9450ca0c24fcae2259b1a20284a277730eeb95ec8fa7bae670eb95464cf31"
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
