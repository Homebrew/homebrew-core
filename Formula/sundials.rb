class Sundials < Formula
  desc "Nonlinear and differential/algebraic equations solver"
  homepage "https://computing.llnl.gov/projects/sundials"
  url "https://github.com/LLNL/sundials/releases/download/v6.5.1/sundials-6.5.1.tar.gz"
  sha256 "4252303805171e4dbdd19a01e52c1dcfe0dafc599c3cfedb0a5c2ffb045a8a75"
  license "BSD-3-Clause"

  livecheck do
    url "https://computing.llnl.gov/projects/sundials/sundials-software"
    regex(/href=.*?sundials[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "40042b84ef8e936a8f3cd821140291cb06d0eaffdcc45f27b87c4ad1a564dad4"
    sha256 cellar: :any,                 arm64_monterey: "00953e653d8249b5de5c57ff35c496e7e46477dd2bd04e28d5b06ef02b5dc6f8"
    sha256 cellar: :any,                 arm64_big_sur:  "cfb4b311c6262eb23a81a11139f5ed4255d0d61935ccc82cab9ec08d1ddca14a"
    sha256 cellar: :any,                 ventura:        "2ac2fa05aa35906349d9f14edb48f6109e88666cfdf5356f1d05e5c537150803"
    sha256 cellar: :any,                 monterey:       "5b4ddd6fc123d2fed0626a96f4513b9c135a1239882c001914932c73e672414e"
    sha256 cellar: :any,                 big_sur:        "f844df977868784d6344a6988d66612c31bece25772fd2986c63034828b3c593"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5307c756f103e39771f00892e6a8d682e89987e935cf425c8a13697716c771ac"
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
