class SlepcComplex < Formula
  desc "Scalable Library for Eigenvalue Problem Computations (complex)"
  homepage "https://slepc.upv.es"
  url "https://slepc.upv.es/download/distrib/slepc-3.26.1.tar.gz"
  sha256 "d9b8bb27f6402e72e9d8f7ae9a1de241ff772b55d0bf265e8e10c61750f49cb9"
  license "BSD-2-Clause"

  livecheck do
    formula "slepc"
  end

  bottle do
    sha256 arm64_golden_gate: "7f840add5705bbdebf81c3ded67bbd8901607b3d4386631dd4066896c9bf0c2d"
    sha256 arm64_tahoe:       "802be17cac3210eb7236743362a81aa7282c5f83ddd383956f9cb3cc92aaad2b"
    sha256 arm64_sequoia:     "2c96a29adcb3994ce95c403460a58ff20f14eb2884d16ee130239f925af26472"
    sha256 arm64_linux:       "618741230266683c686e29333e1a8861fc4fea63e4b875f814dd155b8cd7e5f4"
    sha256 x86_64_linux:      "f910b556aa3bd40cdb30e7157cdfd86be76638c46a26e941b20eb2b8ccbfd4f2"
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

  deny_network_access!

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
