class SlepcComplex < Formula
  desc "Scalable Library for Eigenvalue Problem Computations (complex)"
  homepage "https://slepc.upv.es"
  url "https://slepc.upv.es/download/distrib/slepc-3.24.3.tar.gz"
  sha256 "3f13421f3fcd68fd720a143088506e0f91e24243844703997597eee793225452"
  license "BSD-2-Clause"

  livecheck do
    formula "slepc"
  end

  bottle do
    sha256 arm64_tahoe:   "38296d164dd4d02dda51580e12ab3fbd15e21915db93314c510a7319aaf79641"
    sha256 arm64_sequoia: "4a6ecd78a9ec2e3b9ad5305f5fe36cc39a126526f1b483a5e94c0903a95fc657"
    sha256 arm64_sonoma:  "af98493ddbe906d25bbd6a9fef6a8066028570e7d3d6c8d48f5c411a6349ed7f"
    sha256 sonoma:        "5d619c4f3d185324678448f5494e1d1bca3ade2241dbe1dafa314c661f6658d3"
    sha256 arm64_linux:   "76306619ac7445bad276ee1bc0aee70167a155dbad2577f6b6f72fe0fcc4a72d"
    sha256 x86_64_linux:  "2e9dcb68ec56aac33d443738346cd55926c46d38f32e704c94b4ff4701270e0f"
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
