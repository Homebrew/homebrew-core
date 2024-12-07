class SlepcComplex < Formula
  desc "Scalable Library for Eigenvalue Problem Computations (complex)"
  homepage "https://slepc.upv.es"
  url "https://slepc.upv.es/download/distrib/slepc-3.22.2.tar.gz"
  sha256 "b60e58b2fa5eb7db05ce5e3a585811b43b1cc7cf89c32266e37b05f0cefd8899"
  license "BSD-2-Clause"

  livecheck do
    formula "slepc"
  end

  depends_on "open-mpi"
  depends_on "openblas"
  depends_on "petsc-complex"

  uses_from_macos "python" => :build

  on_linux do
    depends_on "open-mpi"
    depends_on "openblas"
  end

  conflicts_with "slepc", because: "slepc must be installed with either real or complex support, not both"

  def install
    ENV["PETSC_DIR"] = Formula["petsc-complex"].prefix.realpath
    ENV["SLEPC_DIR"] = buildpath

    # Cannot use `std_configure_args` due to fatal error with
    # `--disable-debug`, `--disable-dependency-tracking`, and `--libdir`
    system "./configure", "--prefix=#{prefix}"
    system "make", "all"
    system "make", "install", "PYTHON=#{which("python3")}"

    # Avoid references to Homebrew shims
    rm(lib/"slepc/conf/configure-hash")
  end

  test do
    pform = "petsc-complex"
    flags = %W[-I#{include} -L#{lib} -lslepc -I#{Formula[pform].include} -L#{Formula[pform].lib} -lpetsc]
    flags << "-Wl,-rpath,#{lib} -Wl,-rpath,#{Formula[pform].lib}" if OS.linux?
    system "mpicc", pkgshare/"../slepc/examples/src/eps/tutorials/ex2.c", "-o", "test", *flags
    output = shell_output("./test -terse")
    # This SLEPc example prints several lines of output. The 7th line contains
    # a specific message if everything went well
    line = output.lines.at(-3)
    assert_match "All requested eigenvalues computed up to the required tolerance:", line
  end
end
