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
    sha256 arm64_sequoia: "28a4f94479c586cf452f90911bd643c1781bfc62b787db99a208179d4a7a9549"
    sha256 arm64_sonoma:  "c0917a212c8888bb946ba9ec282bdb60986b2fa29cbaa566fdd160f93f34feed"
    sha256 arm64_ventura: "a8679229f0c2befa3f76feb2c69eb479d3ef882f2436f3ee1784c6634a2fa125"
    sha256 sonoma:        "d73a31882881c83dd96aa0e26694d2d3a3060675ddc919fd04e98631f11f868c"
    sha256 ventura:       "af9d83dae9a5ca03f1c52b3125c4cf0b0f22c667322c49a046fb391e27aee75b"
    sha256 arm64_linux:   "c18fab6ddd8d27ec7474ca34cd91da6dc4f7b5a591525953b62fca6d93359994"
    sha256 x86_64_linux:  "cfa1feab93781a66b95621c6b3433f92a14826ea9beb5d322ffd53aade3c112a"
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
