class SlepcComplex < Formula
  desc "Scalable Library for Eigenvalue Problem Computations (complex)"
  homepage "https://slepc.upv.es"
  url "https://slepc.upv.es/download/distrib/slepc-3.22.2.tar.gz"
  sha256 "b60e58b2fa5eb7db05ce5e3a585811b43b1cc7cf89c32266e37b05f0cefd8899"
  license "BSD-2-Clause"

  livecheck do
    formula "slepc"
  end

  bottle do
    sha256 arm64_sequoia: "ab7353a6dabe7d12b44fe9f606178d93ea79319d12f18196ab8eb7ecdb363e5e"
    sha256 arm64_sonoma:  "8c83602b8ee3da9d3c6037acc701892a06427dcc65196521240f3a28f0d0e425"
    sha256 arm64_ventura: "2454ec267bb175ee89e152eb83ad919099f4469e49f80ec98da6deba0da1510c"
    sha256 sonoma:        "1bf269557030623c97a6524ac992f20ccae2337c41cb0027888d042874d2e82a"
    sha256 ventura:       "74c1ece8bf8ae685f8f9b0817cea8c3b005e949ef8953999c0485af27dd30578"
    sha256 x86_64_linux:  "29b2f617d5cae86c0a023d2aaea35d053f73b06e40f6e705aeeedbc99e2aadb7"
  end

  depends_on "open-mpi"
  depends_on "openblas"
  depends_on "petsc-complex"

  uses_from_macos "python" => :build

  on_macos do
    depends_on "gcc"
  end

  conflicts_with "slepc", because: "slepc must be installed with either real or complex support, not both"

  def install
    ENV["PETSC_DIR"] = Formula["petsc-complex"].prefix.realpath
    ENV["SLEPC_DIR"] = buildpath

    # This is not an autoconf script so cannot use `std_configure_args`
    system "./configure", "--prefix=#{prefix}"
    system "make", "all"
    system "make", "install", "PYTHON=#{which("python3")}"

    # Avoid references to Homebrew shims
    rm(lib/"slepc/conf/configure-hash")
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
