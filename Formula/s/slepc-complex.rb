class SlepcComplex < Formula
  desc "Scalable Library for Eigenvalue Problem Computations (complex)"
  homepage "https://slepc.upv.es"
  url "https://slepc.upv.es/download/distrib/slepc-3.23.3.tar.gz"
  sha256 "6b0c4f706bdfca46f00b30026b4d92a4eb68faa03e40cbcbfeadb89999653621"
  license "BSD-2-Clause"

  livecheck do
    formula "slepc"
  end

  bottle do
    sha256 arm64_tahoe:   "47fcc6ac957db85ebc37b347d4163b5a5da9c08e11f0dd3f36743d4cf4dfd90b"
    sha256 arm64_sequoia: "71a17f6a5888732c17e673160ef3195d1a33792348ddcb643beb8e172eeae9ea"
    sha256 arm64_sonoma:  "043dabac8fed58049d6a90a8b6ab477b66729e59016e627798441a0f18a9c887"
    sha256 arm64_ventura: "24aade23f2bccef39291952a8510afcfc6305a1b744d3429f1751cef9d787118"
    sha256 sonoma:        "a1f405a9a11bc54d41a516a5e090300d93a6abaa11b8565ba03b7c4c1dd95d04"
    sha256 ventura:       "1b900fea15c072e7842c414da58f27b01511952fe524bbcae37cbfc097264e31"
    sha256 arm64_linux:   "7f84644c214f8a8da10473b6aee7d10f9bfb4bf3b444d48b5ecd160998e074ad"
    sha256 x86_64_linux:  "0d8f7a5c6e3eb5aa14bd3e077ab80b2f8e695276a38f3b72c6a93e929b6f8dd8"
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
