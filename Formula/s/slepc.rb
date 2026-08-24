class Slepc < Formula
  desc "Scalable Library for Eigenvalue Problem Computations (real)"
  homepage "https://slepc.upv.es"
  url "https://slepc.upv.es/download/distrib/slepc-3.25.1.tar.gz"
  sha256 "906ddbe15a20774c23ddcdf13a5054889d00a26c3c37463447ee593c757d03ee"
  license "BSD-2-Clause"

  livecheck do
    url "https://slepc.upv.es/download/distrib/"
    regex(/href=.*?slepc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "8874ee29d0cc3bab158d54aa53a1779deb2918f6a376dd3ab31ea11612050e8e"
    sha256 arm64_sequoia: "2b9cca61a89af387f6ddc0932c51c8ca0eab163d48c1001827be37e967ea802f"
    sha256 arm64_sonoma:  "485b3f10ce270642957ce26b392cf435cd6de64e11266a94f26e7b12eca650f5"
    sha256 sonoma:        "2cca12caf6a9bea917e7575469c78ac9fae1e309675c409fd68531706817b997"
    sha256 arm64_linux:   "d5f254d0c757182161d10ee709a13f92369c165b5f7201714f7734e30518bc38"
    sha256 x86_64_linux:  "2c5ecfa3dae73579de05e489d5f816573c921e833519180e6dccf98d1f458a6d"
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
