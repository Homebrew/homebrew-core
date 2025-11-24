class SlepcComplex < Formula
  desc "Scalable Library for Eigenvalue Problem Computations (complex)"
  homepage "https://slepc.upv.es"
  url "https://slepc.upv.es/download/distrib/slepc-3.24.1.tar.gz"
  sha256 "b07e1c335eb620dfc50a2b8d4fb12db03c6929ae624f0338ff8acf879a072abf"
  license "BSD-2-Clause"
  revision 1

  livecheck do
    formula "slepc"
  end

  bottle do
    sha256 arm64_tahoe:   "eb0103ec917730546d4ad8a39103f95bf30937d16116abe252e3bf171ca4824c"
    sha256 arm64_sequoia: "77a47d63de15c088fce53faf923a05408f48a1a8533560f242256e4cf12639f0"
    sha256 arm64_sonoma:  "83474a305995a763ca414a8f022a3e2fa184d3fd264408cd57187aa9b5567cd8"
    sha256 sonoma:        "045624210250083f59474ab492e06765b50769d56d2580a976d45af51037ecb6"
    sha256 arm64_linux:   "de850f2beb300dbd549d9ce531658908a404216b8f32ec8ef5c0dacc5c559f3e"
    sha256 x86_64_linux:  "7f24a470839c30ad0d70a8772543d0834a4cc12d665d2ee0bee29aa02fdcd049"
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
