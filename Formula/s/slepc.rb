class Slepc < Formula
  desc "Scalable Library for Eigenvalue Problem Computations (real)"
  homepage "https://slepc.upv.es"
  url "https://slepc.upv.es/download/distrib/slepc-3.24.3.tar.gz"
  sha256 "3f13421f3fcd68fd720a143088506e0f91e24243844703997597eee793225452"
  license "BSD-2-Clause"

  livecheck do
    url "https://slepc.upv.es/download/distrib/"
    regex(/href=.*?slepc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "7893de8828584ba7616d79633afeed53d9ea42e2c3bb4916a573b77cae57987d"
    sha256 arm64_sequoia: "5d6b4269e1a81eeab116bd4184048dd637aa8582ba0f09c8d224ddf013958e2d"
    sha256 arm64_sonoma:  "adc35644f2573f208a32f73b5f27cc587af940e4db12f1baae3dbe4d814bd2a3"
    sha256 sonoma:        "b32eb532117fd5f0c53086a2bef510b804d3db2cb17c15f8f2e4a240b0d7948d"
    sha256 arm64_linux:   "b0825622cf74b8d515667ad61ee02514fe76c91ff8062dbd656e9d3290a02854"
    sha256 x86_64_linux:  "4b60a87c3dc3e8e76307fff0c3969aac315a8659e685cae52e9fdd4dd6861c21"
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
