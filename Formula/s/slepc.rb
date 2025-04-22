class Slepc < Formula
  desc "Scalable Library for Eigenvalue Problem Computations (real)"
  homepage "https://slepc.upv.es"
  url "https://slepc.upv.es/download/distrib/slepc-3.23.0.tar.gz"
  sha256 "78252f7b2f540c5fdadadee0fd21f3e6eff810f82cb45482f327b524c8db63d0"
  license "BSD-2-Clause"

  livecheck do
    url "https://slepc.upv.es/download/distrib/"
    regex(/href=.*?slepc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "e597393abb871509ecd75318c0e66074a90d5d627fbc3daa0ea322f0522f4014"
    sha256 arm64_sonoma:  "06d5c5d94c2f1b9b591b35e9077895dbcfd38eb1dcdc71d0007e88f6e2e260b0"
    sha256 arm64_ventura: "409a293b849118d3ffdd000e7e535b639d5986ebd1a1001cd83c75dc771941c7"
    sha256 sonoma:        "d8d86c77bb0c98370297ece7cbfbb6d09f514e18da2a53bfbc471b584ddecddf"
    sha256 ventura:       "8b8ecd08eda196f527d4effe1d2803d9920a4d3d2c6dd6be501699de44fbd518"
    sha256 arm64_linux:   "0d1386474fb8f73713f49790662afbafe94d07b9c9309f96c1d0e78de13c7b78"
    sha256 x86_64_linux:  "af5cdf664ca3813c4c311f0ba7a3ac396d2c5b823d396fa1f234ffedd57c230d"
  end

  depends_on "open-mpi"
  depends_on "openblas"
  depends_on "petsc"

  uses_from_macos "python" => :build

  on_macos do
    depends_on "gcc"
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
