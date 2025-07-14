class SlepcComplex < Formula
  desc "Scalable Library for Eigenvalue Problem Computations (complex)"
  homepage "https://slepc.upv.es"
  url "https://slepc.upv.es/download/distrib/slepc-3.23.2.tar.gz"
  sha256 "3060a95692151ef0f9ba4ca11da18d5dcd86697b59f6aeee723de92d7bd465a1"
  license "BSD-2-Clause"

  livecheck do
    formula "slepc"
  end

  bottle do
    sha256 arm64_sequoia: "eca041862a7e638ce2196ef62fe0b5ecbb5bed8ad3e0cdb9141213d87433ddaf"
    sha256 arm64_sonoma:  "2a19160db71c538592e62152abd5b73af1181e6ad486c08c9bccce0082000c7e"
    sha256 arm64_ventura: "ce1f216a7773489d1aaa52e7fb73180232737f11523b4a03b1d8950bc2b332e6"
    sha256 sonoma:        "c571f942b34d1ec21b945ceed0eb23d9d4c113c7d4224ee61699ee0609b928e2"
    sha256 ventura:       "65ee3be4a3daa5b5e59a38410ca924f652959cc6c4159ca6c1e840ffa569334c"
    sha256 arm64_linux:   "e8bf813ab7874a72fed34c824904e1cd83cdc1e8c9524bddef25cc88e885445a"
    sha256 x86_64_linux:  "cfaab5c421f9e40ee475ef8303291be1ec5cac205b374ba67ee770e032b2aaea"
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
