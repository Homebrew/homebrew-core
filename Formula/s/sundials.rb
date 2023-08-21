class Sundials < Formula
  desc "Nonlinear and differential/algebraic equations solver"
  homepage "https://computing.llnl.gov/projects/sundials"
  url "https://github.com/LLNL/sundials/releases/download/v6.6.0/sundials-6.6.0.tar.gz"
  sha256 "f90029b8da846c8faff5530fd1fa4847079188d040554f55c1d5d1e04743d29d"
  license "BSD-3-Clause"

  livecheck do
    url "https://computing.llnl.gov/projects/sundials/sundials-software"
    regex(/href=.*?sundials[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "19f612e9c55be79129d63dcf98ccdd1df828d8c0c2320bd03283b5023cf6c630"
    sha256 cellar: :any,                 arm64_monterey: "d17e912f61413ebf29f8524442a900b65a1a5c0a639b315ed02ffc60275cab1e"
    sha256 cellar: :any,                 arm64_big_sur:  "7cbf64721de476e45e09e423ea8de04d571def9bfa1aab48e0428cea9e8968b2"
    sha256 cellar: :any,                 ventura:        "937d494253bc03f2223782869b58caae6ec967018d54adf379caf24ff1c9f176"
    sha256 cellar: :any,                 monterey:       "841eafce5549ac27d0f1814e6ecd4e645b88a2d75b9ae65f88b2ecc1f232dbc0"
    sha256 cellar: :any,                 big_sur:        "7de5eb895847aaf8a19e4d5dfd661b7f37366e1c75af2ca14f6fc988ff374446"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56d5f74f4ff14170811c970cabb287f869cdf716a60beaf91b26eb7c69a126e2"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "open-mpi"
  depends_on "openblas"
  depends_on "suite-sparse"

  uses_from_macos "libpcap"

  def install
    blas = "-L#{Formula["openblas"].opt_lib} -lopenblas"
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DKLU_ENABLE=ON
      -DKLU_LIBRARY_DIR=#{Formula["suite-sparse"].opt_lib}
      -DKLU_INCLUDE_DIR=#{Formula["suite-sparse"].opt_include}
      -DLAPACK_ENABLE=ON
      -DLAPACK_LIBRARIES=#{blas};#{blas}
      -DMPI_ENABLE=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Only keep one example for testing purposes
    (pkgshare/"examples").install Dir[prefix/"examples/nvector/serial/*"] \
                                  - Dir[prefix/"examples/nvector/serial/{CMake*,Makefile}"]
    (prefix/"examples").rmtree
  end

  test do
    cp Dir[pkgshare/"examples/*"], testpath
    system ENV.cc, "test_nvector.c", "test_nvector_serial.c", "-o", "test",
                   "-I#{include}", "-L#{lib}", "-lsundials_nvecserial", "-lm"
    assert_match "SUCCESS: NVector module passed all tests",
                 shell_output("./test 42 0")
  end
end
