class SlepcComplex < Formula
  desc "Scalable Library for Eigenvalue Problem Computations (complex)"
  homepage "https://slepc.upv.es"
  url "https://slepc.upv.es/download/distrib/slepc-3.24.0.tar.gz"
  sha256 "6e2d14c98aa9138ac698a2a04a7c6a9f9569988f570b2cfbe4935d32364cb4e9"
  license "BSD-2-Clause"
  revision 1

  livecheck do
    formula "slepc"
  end

  bottle do
    sha256 arm64_tahoe:   "a72cb49002a91474913dd18219c9deda39f5ce136a07507f9605d21f0aeed000"
    sha256 arm64_sequoia: "fe4d40ceaa36e35b0e467e75092028f9462f0e4aa8ec70463f80c6c75365f36d"
    sha256 arm64_sonoma:  "954bd154dd2d29e620e048eb5b6e755e2249d80d878de008d0d679c8ff1781ad"
    sha256 sonoma:        "e3fe442a0d73fe8b153d68c26ace44304835fc8b33aac0f6c85b1d1199506a33"
    sha256 arm64_linux:   "cd10203cc0b50030327827b102d4609e6d499d98003405d5213fdc44da4ef3e7"
    sha256 x86_64_linux:  "5bebcdbff4f3fcd26e5c049fa0906a907a41715efa3676c65004fea734f98d9e"
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
