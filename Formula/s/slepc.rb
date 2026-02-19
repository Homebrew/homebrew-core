class Slepc < Formula
  desc "Scalable Library for Eigenvalue Problem Computations (real)"
  homepage "https://slepc.upv.es"
  url "https://slepc.upv.es/download/distrib/slepc-3.24.2.tar.gz"
  sha256 "6f1f7e45b9bbd15631562f193284832ae4e9655eb3af7f1ba59bdf8bdaefb638"
  license "BSD-2-Clause"
  revision 1

  livecheck do
    url "https://slepc.upv.es/download/distrib/"
    regex(/href=.*?slepc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "f8a0d07e4438573d61b32608da83121bf0d6c29cf99f437fcd7bbdd2f9103572"
    sha256 arm64_sequoia: "ea5bfedaa28046c95f73382ac8b82181956193c067dbdca4ac1a620d43b5b669"
    sha256 arm64_sonoma:  "7aeeeb93bd4fe4931c1269bd24562705734eff80010bfc933fd1f3c6d7c0c80f"
    sha256 sonoma:        "6b2b9207882bb06cf37ad0c79e47adc366f7c33c257c2f35da5001c59c442bd8"
    sha256 arm64_linux:   "51cc7f2d18cac19dd45c720b727f48b62ba986ae3585ffbe69528dd973ce2682"
    sha256 x86_64_linux:  "77b9c8642b9ad527e6df71cdbe7c93d9478bcbdc1e9ed3ec1052a1fccdf56162"
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
