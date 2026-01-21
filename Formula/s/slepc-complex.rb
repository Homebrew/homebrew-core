class SlepcComplex < Formula
  desc "Scalable Library for Eigenvalue Problem Computations (complex)"
  homepage "https://slepc.upv.es"
  url "https://slepc.upv.es/download/distrib/slepc-3.24.2.tar.gz"
  sha256 "6f1f7e45b9bbd15631562f193284832ae4e9655eb3af7f1ba59bdf8bdaefb638"
  license "BSD-2-Clause"

  livecheck do
    formula "slepc"
  end

  bottle do
    sha256 arm64_tahoe:   "97dd1650a3aa0dea1116fd15c58a56f41d8917a5bd56d3b883e463199942b1e8"
    sha256 arm64_sequoia: "98d2d4a4310377396fe7e8716b5691f598030566c384c52939680e3ac99bcc6c"
    sha256 arm64_sonoma:  "1f9604a22706789b8cd42c72c5fbeec646512d98683c7cec356f6036889f4d71"
    sha256 sonoma:        "4d18c4c48a8910040aa9014eaf8693f8a9980cbfac91a60ba9d14203d5723c1e"
    sha256 arm64_linux:   "85ecf1c09c85d51164656999b842ec4c001ad02a8a01540199068c871f8b6305"
    sha256 x86_64_linux:  "fafdd44777bdae17328bee9a8bf6b91d6dce229c40c05660eee556d3f2ce1dce"
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
