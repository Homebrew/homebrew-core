class Slepc < Formula
  desc "Scalable Library for Eigenvalue Problem Computations (real)"
  homepage "https://slepc.upv.es"
  url "https://slepc.upv.es/download/distrib/slepc-3.23.2.tar.gz"
  sha256 "3060a95692151ef0f9ba4ca11da18d5dcd86697b59f6aeee723de92d7bd465a1"
  license "BSD-2-Clause"

  livecheck do
    url "https://slepc.upv.es/download/distrib/"
    regex(/href=.*?slepc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "f50cb13f0cf0c389ebe7de1ddcb8cb3b2f1ab0428d21211467cbfb3b7c2f2f52"
    sha256 arm64_sonoma:  "60050a98b9bdc94ca6f30212c6a06fe6f3a1be2fa69c615a24e1da6e60c77542"
    sha256 arm64_ventura: "33408f88315c4d42fc38cea561dabd7b06abfe713eca9b6a9f94f85b03cd8d8d"
    sha256 sonoma:        "c807ecf72cf4cd8a813b0806f01562545305d0e2f0256d382575c2a44119e83e"
    sha256 ventura:       "6d22743ad3c45f706a5feaee124a4ec1854aeffa707682ac0e207d89dcdbc4f0"
    sha256 arm64_linux:   "1d8987e2e6c132c59dd00a47a039e276b48423001b904db655e6aae49242ef5c"
    sha256 x86_64_linux:  "69bb506a23835dd9afa4b12096c8b80ad3f16f69ddef4431991a5051c7df693f"
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
