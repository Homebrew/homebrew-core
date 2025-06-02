class Slepc < Formula
  desc "Scalable Library for Eigenvalue Problem Computations (real)"
  homepage "https://slepc.upv.es"
  url "https://slepc.upv.es/download/distrib/slepc-3.23.1.tar.gz"
  sha256 "c2fde066521bbccfbc80aa15182bca69ffaf00a7de648459fd04b81589896238"
  license "BSD-2-Clause"

  livecheck do
    url "https://slepc.upv.es/download/distrib/"
    regex(/href=.*?slepc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "f85955c046f0968313562108a8fd6aa37928c3e26559eca7f352d01b730d6ae8"
    sha256 arm64_sonoma:  "f1c54fbc2661b9d01fb6325be8ee246b41e11671b06254d59c35181196092f87"
    sha256 arm64_ventura: "085717ceafb7c6d9db2c70d126ee94a9be50ff389760d2a925421e093084e08e"
    sha256 sonoma:        "9a8b14ecab42a75016f04933d51f17859f3cb3d1eb3165ed7e1568741a7883c1"
    sha256 ventura:       "75a1e30f69b215aedc43ae79864fd38893ad7141e7a8a2b4130444e8ac606393"
    sha256 arm64_linux:   "d1c3609f9fc9e5f64aa84c68bafccee996b26b2374f91005b97f8d352625fd88"
    sha256 x86_64_linux:  "82e8f7056e01c96ff02f541d714960b08be64bd60a328ab24b1c978d3bb4a3d0"
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
