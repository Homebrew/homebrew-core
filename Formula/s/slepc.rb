class Slepc < Formula
  desc "Scalable Library for Eigenvalue Problem Computations (real)"
  homepage "https://slepc.upv.es"
  url "https://slepc.upv.es/download/distrib/slepc-3.24.2.tar.gz"
  sha256 "6f1f7e45b9bbd15631562f193284832ae4e9655eb3af7f1ba59bdf8bdaefb638"
  license "BSD-2-Clause"

  livecheck do
    url "https://slepc.upv.es/download/distrib/"
    regex(/href=.*?slepc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "e08ee33f372159eebd55faa24c2c5adb5a9c9a3abcf6b7260177831db3a2b494"
    sha256 arm64_sequoia: "469a5f5de239aced7884b2f2c3bb09ceea691eb81e9980f5f4941a94aa2d779b"
    sha256 arm64_sonoma:  "d48074230da2aeb19bb439b31965c11b1add93ba61826a0803dff4d923b4d067"
    sha256 sonoma:        "e8170f1ea5bd40bcbff6f0dcfd444326a65198d7ee805b63fa2f30f88af9c2c1"
    sha256 arm64_linux:   "a93015014d7aeef6fe30f24394596aefae1585cf393d5183f59cf7f9573099d2"
    sha256 x86_64_linux:  "13aed4125057245c849c4b399d68145acbda7d98543fc04ca69f0a94e9b29f10"
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
