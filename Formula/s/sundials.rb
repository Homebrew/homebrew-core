class Sundials < Formula
  desc "Nonlinear and differential/algebraic equations solver"
  homepage "https://computing.llnl.gov/projects/sundials"
  url "https://github.com/llnl/sundials/releases/download/v7.8.0/sundials-7.8.0.tar.gz"
  sha256 "69ec92653e998e4841b59d363b3abf21299251991390f52917402737164ca574"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e402f0af1b35c067a78c4cc3c5ce786ef1de199ff95c279520ff4320d55d477e"
    sha256 cellar: :any, arm64_sequoia: "f276618c25e165819a634d92ddd457ffed2df3fdee6d9a79b24ac21864d95697"
    sha256 cellar: :any, arm64_sonoma:  "766ff5217faa01994079383f061cc029c7a4ea1d2e3bf0f72c00b52f0d15046c"
    sha256 cellar: :any, sonoma:        "21cbec7b940c651ec5dac8afc440b9a354439016f2da761f6948fb306d8cdc8d"
    sha256 cellar: :any, arm64_linux:   "8e0502e923b081b68263e25447d0a60e1d57c47c3033267a71e01de2ba07e1bf"
    sha256 cellar: :any, x86_64_linux:  "d8e2323ab2d8339c1cfbdb60123fbeea16774c5ab19d160246a3ac0b62d1f5d4"
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
