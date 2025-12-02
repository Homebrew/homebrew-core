class Sundials < Formula
  desc "Nonlinear and differential/algebraic equations solver"
  homepage "https://computing.llnl.gov/projects/sundials"
  url "https://github.com/LLNL/sundials/releases/download/v7.5.0/sundials-7.5.0.tar.gz"
  sha256 "089ac659507def738b7a65b574ffe3a900d38569e3323d9709ebed3e445adecc"
  license "BSD-3-Clause"

  livecheck do
    url "https://computing.llnl.gov/projects/sundials/sundials-software"
    regex(/href=.*?sundials[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bdca6a1965e3c4d23438f226a3538d52d500466e25936a0cb2c6602ce634649f"
    sha256 cellar: :any,                 arm64_sequoia: "6d96641c4b35e673d83df8cd8a77ec055e656521b34a0913e04c9b66b79131f5"
    sha256 cellar: :any,                 arm64_sonoma:  "52797bd57e4862acd1dde93475613a8c7928c8f1bc0cbb22c06d25b1e0c9ac6c"
    sha256 cellar: :any,                 sonoma:        "cf97a4b063dd8ec56ca682bc2aa33444b5cd90e02c82e6b6eb70c3b7b344a531"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e3d8fc19a1cf7cfd31037d7f7899150cc43e19b79eab8af0f1424b6a4cfee8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d46ac702b24f49dc7ae07a1ea2514876806b64c1c1418507f1abe5a7d00d70b"
  end

  depends_on "cmake" => :build
  depends_on "open-mpi"
  depends_on "openblas"
  depends_on "suite-sparse"

  def install
    blas = "-L#{Formula["openblas"].opt_lib} -lopenblas"
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DENABLE_KLU=ON
      -DENABLE_LAPACK=ON
      -DENABLE_MPI=ON
      -DKLU_LIBRARY_DIR=#{Formula["suite-sparse"].opt_lib}
      -DKLU_INCLUDE_DIR=#{Formula["suite-sparse"].opt_include}/suitesparse
      -DLAPACK_LIBRARIES=#{blas};#{blas}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Only keep one example for testing purposes
    (pkgshare/"examples").install Dir[
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

    args += ["-I#{Formula["open-mpi"].opt_include}", "-L#{Formula["open-mpi"].opt_lib}"] if OS.mac?

    system ENV.cc, "test_nvector.c", "test_nvector_serial.c", "-o", "test", *args

    assert_match "SUCCESS: NVector module passed all tests", shell_output("./test 42 0")
  end
end
