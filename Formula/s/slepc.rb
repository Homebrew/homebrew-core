class Slepc < Formula
  desc "Scalable Library for Eigenvalue Problem Computations (real)"
  homepage "https://slepc.upv.es"
  url "https://slepc.upv.es/download/distrib/slepc-3.24.1.tar.gz"
  sha256 "b07e1c335eb620dfc50a2b8d4fb12db03c6929ae624f0338ff8acf879a072abf"
  license "BSD-2-Clause"
  revision 1

  livecheck do
    url "https://slepc.upv.es/download/distrib/"
    regex(/href=.*?slepc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "f1bc43d092ee588b25319c985c652a41f87ea7e7302c21194b54b687508c1c31"
    sha256 arm64_sequoia: "ea9b9b1032eefddb49f429e68295adcce9016427670774bc156fe3ed923c0c6f"
    sha256 arm64_sonoma:  "3dedb3b86719fa6c5b4673ed62b33feb4cf9a8f306271c274dc74d8ec79bfe3b"
    sha256 sonoma:        "6b652f498ce4435f9a685cb1aac1741c805a84c19b10ced165f14ffe42b51842"
    sha256 arm64_linux:   "a673f131974f2253ad2b69a8e4fe00973a23c6b1768d013a59e94e2bbbf3f486"
    sha256 x86_64_linux:  "a884c68ed5f1b0c1cb32a9664ac6c24b582be2b3e56b7070d461f2271b5bfb16"
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
