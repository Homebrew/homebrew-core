class Sundials < Formula
  desc "Nonlinear and differential/algebraic equations solver"
  homepage "https://computing.llnl.gov/projects/sundials"
  url "https://github.com/llnl/sundials/releases/download/v7.9.0/sundials-7.9.0.tar.gz"
  sha256 "13f898a27b48fe3449483f9e438a800ed545abf93bc2e2ceec2d1e00ae8db5ef"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7e73351e64d9d93d9df664b0b57233ac5fcdc3c180ff2aca85ba158af478ba08"
    sha256 cellar: :any, arm64_sequoia: "1851856136d77acc4d206f38a7340429d975046bcc57c92e49c934b3eb2a2955"
    sha256 cellar: :any, arm64_sonoma:  "4ba3ce27952cedc18da261da008b6750345887675cb48d3a0bef975b8a5bdd47"
    sha256 cellar: :any, arm64_linux:   "99c4eff4d5690e328568ff6faf650e0b72a71bc024c80e4a69f75601ee045375"
    sha256 cellar: :any, x86_64_linux:  "41ed04d600eee6b797e58d58bbe8435248c249e313f90d02bc09cac2aea1c0a8"
  end

  depends_on "cmake" => :build
  depends_on "open-mpi"
  depends_on "openblas"
  depends_on "suite-sparse"

  def install
    args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DENABLE_KLU=ON
      -DENABLE_LAPACK=ON
      -DENABLE_MPI=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Only keep one example for testing purposes
    (pkgshare/"examples").install [
      "test/unit_tests/nvector/test_nvector.c",
      "test/unit_tests/nvector/test_nvector.h",
      "test/unit_tests/nvector/serial/test_nvector_serial.c",
    ]
    rm_r(prefix/"examples")
  end

  test do
    cp Dir[pkgshare/"examples/*"], testpath
    args = %W[
      -I#{include}
      -L#{lib}
      -lsundials_core
      -lsundials_nvecserial
      -lmpi
      -lm
    ]

    args += ["-I#{formula_opt_include("open-mpi")}", "-L#{formula_opt_lib("open-mpi")}"] if OS.mac?

    system ENV.cc, "test_nvector.c", "test_nvector_serial.c", "-o", "test", *args

    assert_match "SUCCESS: NVector module passed all tests", shell_output("./test 42 0")
  end
end
