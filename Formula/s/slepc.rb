class Slepc < Formula
  desc "Scalable Library for Eigenvalue Problem Computations (real)"
  homepage "https://slepc.upv.es"
  url "https://slepc.upv.es/download/distrib/slepc-3.23.3.tar.gz"
  sha256 "6b0c4f706bdfca46f00b30026b4d92a4eb68faa03e40cbcbfeadb89999653621"
  license "BSD-2-Clause"

  livecheck do
    url "https://slepc.upv.es/download/distrib/"
    regex(/href=.*?slepc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "b0328ec284eb58dfd9f3da35143d375b6d7e7a1b627be6fe52779009a88253b9"
    sha256 arm64_sequoia: "1e8625e2aaeba2e2888b43eca1d69393775ecede8909ad7961df87f2b3c00fa0"
    sha256 arm64_sonoma:  "46b520c6c7ead28a03d67508275d37fe81277ac0d76a4a2ae1c06892c399b3a8"
    sha256 arm64_ventura: "3a43b401e9d7668c8e93db2b833ba8bebad088ba9ca76137429b1fe492251701"
    sha256 sonoma:        "5cc3dca86a7ceca9e1732b4c950ac4693a60c33c84843ce75ebbce2acea9eb90"
    sha256 ventura:       "cded8dca5b40bfcc10db737e31f882a24c3c5d9ecc7e4dd18aaa145153681256"
    sha256 arm64_linux:   "daa773b0485c9b0de910df85fa77f3cfcf01e66b65953c9d0544eeb631296b7e"
    sha256 x86_64_linux:  "67830e96b566ac07b2cdf39bf7a731369b758bf6a36bda24a3f4a5dbfedc5fa0"
  end

  depends_on "open-mpi"
  depends_on "openblas"
  depends_on "petsc"
  depends_on "scalapack"

  uses_from_macos "python" => :build

  on_macos do
    depends_on "fftw"
    depends_on "gcc"
    depends_on "hdf5-mpi"
    depends_on "metis"
  end

  conflicts_with "slepc-complex", because: "slepc must be installed with either real or complex support, not both"

  def install
    ENV["PETSC_DIR"] = Formula["petsc"].prefix.realpath
    ENV["SLEPC_DIR"] = buildpath

    # This is not an autoconf script so cannot use `std_configure_args`
    system "./configure", "--prefix=#{prefix}"
    system "make", "all"
    system "make", "install", "PYTHON=#{which("python3")}"
  end

  test do
    pform = "petsc"
    flags = %W[-I#{include} -L#{lib} -lslepc -I#{Formula[pform].include} -L#{Formula[pform].lib} -lpetsc]
    flags << "-Wl,-rpath,#{lib},-rpath,#{Formula[pform].lib}" if OS.linux?
    system "mpicc", pkgshare/"examples/src/eps/tutorials/ex2.c", "-o", "test", *flags
    output = shell_output("./test -terse")
    # This SLEPc example prints several lines of output. The 7th line contains
    # a specific message if everything went well
    line = output.lines.at(-3)
    assert_match "All requested eigenvalues computed up to the required tolerance:", line
  end
end
