class Slepc < Formula
  desc "Scalable Library for Eigenvalue Problem Computations (real)"
  homepage "https://slepc.upv.es"
  url "https://slepc.upv.es/download/distrib/slepc-3.25.2.tar.gz"
  sha256 "65795612fd50efd77d151bb884b0075429fe12c532963e38081988a5ed6efbd5"
  license "BSD-2-Clause"

  livecheck do
    url "https://slepc.upv.es/download/distrib/"
    regex(/href=.*?slepc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "05eb379a03cd629d37ed1d07912079ae5c3df3df5d08bc27c72ac6325fe3a9a5"
    sha256 arm64_tahoe:       "f1bc932b06d91298af4822bb9c8961e1d8d5d27027ab6ec6db70ef928fe17f67"
    sha256 arm64_sequoia:     "062600909239156ffe850f080d9764683684c8dfa81138a45b96bf86d9f1fe6b"
    sha256 arm64_linux:       "8b9bf10c8fb0bb3eba74341f5445cc69bd7bad42623dbb3d6f9638613fe4055a"
    sha256 x86_64_linux:      "4f0dd76f8066ca261c2bbbdbe390ec3ee03d3a3a8bb44d99856bac2fdd409715"
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
