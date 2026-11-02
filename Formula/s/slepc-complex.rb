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
    sha256 arm64_golden_gate: "5164ca7efd2f195ab43a07877a61cbbacec33de4742d0de5c70a3ed1648bd552"
    sha256 arm64_tahoe:       "d70ce2e90780d62ebc62a718f40af3b6a8d7cba55d416d76c996b17063279224"
    sha256 arm64_sequoia:     "6c8d907785699a08cc8854fe0279eeca3f7a25d3a9cece55eb845a17bb724b2b"
    sha256 arm64_linux:       "51f467348374f6e815324fba32bafcab4cdec60790d5ef756579a585657b5447"
    sha256 x86_64_linux:      "32395eb0d2508dc6b7121b89b4cd16740c7dc75a62d813f35585dd2d5015d83c"
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
