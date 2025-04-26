class SlepcComplex < Formula
  desc "Scalable Library for Eigenvalue Problem Computations (complex)"
  homepage "https://slepc.upv.es"
  url "https://slepc.upv.es/download/distrib/slepc-3.23.0.tar.gz"
  sha256 "78252f7b2f540c5fdadadee0fd21f3e6eff810f82cb45482f327b524c8db63d0"
  license "BSD-2-Clause"

  livecheck do
    formula "slepc"
  end

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "7127c06c486a284343f4a308ad54eb0cbf624f163fce126b96a3c4aa3bccd647"
    sha256 arm64_sonoma:  "e2bc68272cf1a631d123b5dc55479ab44b811ee2129094a5532087ae6005c8bf"
    sha256 arm64_ventura: "cf049f68cdf38ea865edb4a1169d8811a69902ec7fe884e3fe09d5a5247342d1"
    sha256 sonoma:        "b855ca0f3ceb2850253d4cd801783d521e1220868b42126bb902a8023e4b5601"
    sha256 ventura:       "b3e860d090577fcb728fe14b7ac57f6ba27d091dd46b84f11afdcf09c0bb888e"
    sha256 arm64_linux:   "3404a7a85532b3f1fbe5a6b641296ddda109242f6237954548675497fd8f33f8"
    sha256 x86_64_linux:  "e4db03472502c0136b518d858547a434a2832374f25d63d69b81770e0ee206d2"
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
