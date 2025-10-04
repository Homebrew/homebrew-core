class Slepc < Formula
  desc "Scalable Library for Eigenvalue Problem Computations (real)"
  homepage "https://slepc.upv.es"
  url "https://slepc.upv.es/download/distrib/slepc-3.24.0.tar.gz"
  sha256 "6e2d14c98aa9138ac698a2a04a7c6a9f9569988f570b2cfbe4935d32364cb4e9"
  license "BSD-2-Clause"
  revision 1

  livecheck do
    url "https://slepc.upv.es/download/distrib/"
    regex(/href=.*?slepc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "45a00f99761ad2213e76bdb00f5bf406c29c06ea25ff1b164632b755e4ccf6da"
    sha256 arm64_sequoia: "3f589a3256bf3ea36bd477d171d9cb70f588567519adcbf505a454ee4a13ab90"
    sha256 arm64_sonoma:  "ef18bb14a4e329cf87f65ffccd815c0ac04b1b449e5566050d6b8b0ab38dec13"
    sha256 sonoma:        "6c77df4e29f993c281ce5017a9aac46132b05af52a63ab5dbf2c2a9d30e49378"
    sha256 arm64_linux:   "a393e0706312135ee3c3144f6f063fafc341c151066dc3a985f69e5afe9324ee"
    sha256 x86_64_linux:  "4f62bad47ad40e31bba1801bf525b2f04746905e1bb72a084270e79cd3cb82e3"
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
