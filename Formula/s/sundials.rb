class Sundials < Formula
  desc "Nonlinear and differential/algebraic equations solver"
  homepage "https://computing.llnl.gov/projects/sundials"
  url "https://github.com/LLNL/sundials/releases/download/v7.2.1/sundials-7.2.1.tar.gz"
  sha256 "3781e3f7cdf372ca12f7fbe64f561a8b9a507b8a8b2c4d6ce28d8e4df4befbea"
  license "BSD-3-Clause"

  livecheck do
    url "https://computing.llnl.gov/projects/sundials/sundials-software"
    regex(/href=.*?sundials[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "db1ede463b5ac940844d33fddb8d3a5a482c5a86c696bc7f4c35c9fccc44ce0f"
    sha256 cellar: :any,                 arm64_sonoma:  "35090ef4269eec7b77c60f030a2918df9699a1c4f6ea9fe3783def9ba6c816bc"
    sha256 cellar: :any,                 arm64_ventura: "c88629bb65b804f8a36751d4d7b38ba7ef00eba7fa27853a26ca9c8f2a8b8306"
    sha256 cellar: :any,                 sonoma:        "b1842b88bb89d15e7e2f1fcf549b2a48f4e5b3f7c9275c86fd4421d5f22c611d"
    sha256 cellar: :any,                 ventura:       "734bb3a415f6647d7fe6482fa6958fe967455a8c050a356cfd3d038593d727df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ee65d6f4c0ca10da972dbbe5304ca7b39918776395fddb197a2e16908de1dfa"
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
      -DKLU_INCLUDE_DIR=#{Formula["suite-sparse"].opt_include}/suitesparse
      -DLAPACK_ENABLE=ON
      -DLAPACK_LIBRARIES=#{blas};#{blas}
      -DMPI_ENABLE=ON
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
