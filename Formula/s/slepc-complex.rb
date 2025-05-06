class SlepcComplex < Formula
  desc "Scalable Library for Eigenvalue Problem Computations (complex)"
  homepage "https://slepc.upv.es"
  url "https://slepc.upv.es/download/distrib/slepc-3.23.1.tar.gz"
  sha256 "c2fde066521bbccfbc80aa15182bca69ffaf00a7de648459fd04b81589896238"
  license "BSD-2-Clause"

  livecheck do
    formula "slepc"
  end

  bottle do
    sha256 arm64_sequoia: "9830090d1780c1211954b2b7fd709606554114b9b89f7c8bf8081bbcc514d2cd"
    sha256 arm64_sonoma:  "857fdfdfe8f7ee48fd6f9c99d162981589c710595c7bcd1b4986054bea57d074"
    sha256 arm64_ventura: "2773785a5ba69b69818487f395fc074a487a74544bb5e5d82a1909ed5b9c48c8"
    sha256 sonoma:        "b7de7219d613a3c02be04991a02c7c8721cdecec71a56162955278bcfdc7309e"
    sha256 ventura:       "b0403a30a90ece73c53f93c120560138a084a61891a9d54f6330f8a250220adb"
    sha256 arm64_linux:   "1fb5c956465ecfdd394283ca0bd7b05a9cd632e863ed69e69b78cb84c3d06997"
    sha256 x86_64_linux:  "38de5eacb565a6fb14dd007e5b1c52d5d53048cf2f33f9fde83c89c19a66863e"
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
