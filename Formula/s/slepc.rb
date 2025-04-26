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
    rebuild 1
    sha256 arm64_sequoia: "020860b419ff93bf928409591c47ae78cf9dc0fa773d61879118c0df7f04d5f3"
    sha256 arm64_sonoma:  "7937ec1b3403f45f706b32c792868495012fc81f4e54d4fbd7163d53723700f3"
    sha256 arm64_ventura: "64b6c5a1dca908649a38a3e25254baef0c9a467dcfffeab8ae16401ae8563968"
    sha256 sonoma:        "7a451a2d95c38f9b9f36eea52d89a74ac26f20e57f56303554f46131be12d89e"
    sha256 ventura:       "84d431cb09bbcf8f96f10776b928d182b4896eb560ed844cea821af17880f4e3"
    sha256 arm64_linux:   "576e7fd478aa0bfabc13ef4c80172c6111776d949e4bd104d5ea01ed03ae39f5"
    sha256 x86_64_linux:  "99834bf2f3fe7a059b1ea219e5c09d6b4a032ac50b4e35ceaffa290e0ef3fde3"
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
