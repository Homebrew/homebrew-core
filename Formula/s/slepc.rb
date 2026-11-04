class Slepc < Formula
  desc "Scalable Library for Eigenvalue Problem Computations (real)"
  homepage "https://slepc.upv.es"
  url "https://slepc.upv.es/download/distrib/slepc-3.26.1.tar.gz"
  sha256 "d9b8bb27f6402e72e9d8f7ae9a1de241ff772b55d0bf265e8e10c61750f49cb9"
  license "BSD-2-Clause"

  livecheck do
    url "https://slepc.upv.es/download/distrib/"
    regex(/href=.*?slepc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "b2d3679e2908d87c0b2c921ccd81b767e34fa773b84a6f41b05c994c3eb6e3cd"
    sha256 arm64_tahoe:       "8a37985bac8805d059d829f644750f10fe4d3c049502ec3829cf4c08aa7667f5"
    sha256 arm64_sequoia:     "2351ccbf993f718b851b37bc1903f8f2981ce881a6e63f66c4f0a9bc81d6535d"
    sha256 arm64_linux:       "5554386cd4d1d57a2d8c4ca026b074a6428edff023d81c754d6048823a6147e0"
    sha256 x86_64_linux:      "e9ca740b2b4b55e3835ca72d971d8af8d9b2da9c866de9413fd04becd0843ad7"
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

  deny_network_access!

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
    flags = %W[-I#{include} -L#{lib} -lslepc -I#{formula_opt_include(pform)} -L#{formula_opt_lib(pform)} -lpetsc]
    flags << "-Wl,-rpath,#{lib},-rpath,#{formula_opt_lib(pform)}" if OS.linux?
    system "mpicc", pkgshare/"examples/src/eps/tutorials/ex2.c", "-o", "test", *flags
    output = shell_output("./test -terse")
    # This SLEPc example prints several lines of output. The 7th line contains
    # a specific message if everything went well
    line = output.lines.at(-3)
    assert_match "All requested eigenvalues computed up to the required tolerance:", line
  end
end
