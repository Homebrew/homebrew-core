class Slepc < Formula
  desc "Scalable Library for Eigenvalue Problem Computations (real)"
  homepage "https://slepc.upv.es"
  url "https://slepc.upv.es/download/distrib/slepc-3.22.2.tar.gz"
  sha256 "b60e58b2fa5eb7db05ce5e3a585811b43b1cc7cf89c32266e37b05f0cefd8899"
  license "BSD-2-Clause"

  livecheck do
    url "https://slepc.upv.es/download/distrib/"
    regex(/href=.*?slepc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "d65d1f7f316b0262f89880602af589790ebe17a1f5b9031e77db219ba9fcc365"
    sha256 arm64_sonoma:  "9c4e461e155f83e922980cae2864824891b327f78562c3fe92d79afc3b8b8551"
    sha256 arm64_ventura: "b1415373f667cf826e394a40cdfcd653c530ba9e0fd883c9bcf1ac2e3b96eeb5"
    sha256 sonoma:        "64f48ee58323e9b79092bb356ed3dc231b9fe06dc3e91341ea95ec3089ff9083"
    sha256 ventura:       "f7f143d03d5f90821ff06740345e7f4b939a59fdad3c821759fd29904243d087"
    sha256 x86_64_linux:  "a5ff1205d46e9b21332791a2695bac0c48386e08e6fbc2b8a1ee27b02421220c"
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

    # Avoid references to Homebrew shims
    rm(lib/"slepc/conf/configure-hash")
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
