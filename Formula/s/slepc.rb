class Slepc < Formula
  desc "Scalable Library for Eigenvalue Problem Computations (real)"
  homepage "https://slepc.upv.es"
  url "https://slepc.upv.es/download/distrib/slepc-3.26.1.tar.gz"
  sha256 "d9b8bb27f6402e72e9d8f7ae9a1de241ff772b55d0bf265e8e10c61750f49cb9"
  license "BSD-2-Clause"

  livecheck do
    url "https://slepc.upv.es/download/distrib/"
    regex(/href=.*?slepc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "4a0c1b72bc29bc5a7f6212b45827bfcb919d84d99d83fe993f7864e082534827"
    sha256 arm64_tahoe:       "da6676e7738de42ab9e8882e9ac1c1bb7d528155e626c9a6b27206e784c22a43"
    sha256 arm64_sequoia:     "83fe0503c1e1a300327dd32326ad37a188e865f97b69660b31e4f07558295aa6"
    sha256 arm64_linux:       "7298d7127faff7145cce2f5809cfd348eae0ba40a07e5f905b6a24a58a0a0e2b"
    sha256 x86_64_linux:      "d166222a0e79679142093e1dc5dc443d9b8f1fbbacaf067ba51142801a73ce05"
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
    flags = %W[-I#{include} -L#{lib} -lslepc -I#{formula_opt_include(pform)} -L#{formula_opt_lib(pform)} -lpetsc]
    flags << "-Wl,-rpath,#{lib},-rpath,#{formula_opt_lib(pform)}" if OS.linux?
    system "mpicc", pkgshare/"examples/src/eps/tutorials/ex2.c", "-o", "test", *flags
    output = shell_output("./test -terse")
    # This SLEPc example prints several lines of output. The 7th line contains
    # a specific message if everything went well
    line = output.lines.at(-3)
    assert_match "All requested eigenvalues computed up to the required tolerance:", line
  end
end
