class Sundials < Formula
  desc "Nonlinear and differential/algebraic equations solver"
  homepage "https://computing.llnl.gov/projects/sundials"
  url "https://github.com/LLNL/sundials/releases/download/v7.3.0/sundials-7.3.0.tar.gz"
  sha256 "fd970a9023f8ea37b81c5065c067bf1726f656b39f5907b48169a6f98d306ba7"
  license "BSD-3-Clause"

  livecheck do
    url "https://computing.llnl.gov/projects/sundials/sundials-software"
    regex(/href=.*?sundials[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4ecec4e8bf4e1b6e572703cf17f0bfcb9285455dee39c16e35faa27f99f0fdaf"
    sha256 cellar: :any,                 arm64_sonoma:  "82594d8cbaef0cbe0900eec063fdba9efc1e4cf03d60e2bac49ae88f098ecd40"
    sha256 cellar: :any,                 arm64_ventura: "3b657e3cddd3e81ecdf080e08803e88b9f9d8c1266e168f3434f85e85c991910"
    sha256 cellar: :any,                 sonoma:        "86a6f5675566ea55e2e41371e2d1b6273629bfb0bf9cf2d973a596e4f7965f63"
    sha256 cellar: :any,                 ventura:       "ad6239a7fc87965e8c83e5c7215c8c952995cd45259d3b88d5dbbe53c5b2f32b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7075989ebd108d0bc53b137af6239174fbd6ccb8aa7e1af0b009be26e3c6aef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd6c4d6a5f8ff05623f58a8739b5aebb6db1aa2e723df0fb0c420174205cec87"
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
