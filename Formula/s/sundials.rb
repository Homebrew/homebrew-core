class Sundials < Formula
  desc "Nonlinear and differential/algebraic equations solver"
  homepage "https://computing.llnl.gov/projects/sundials"
  url "https://github.com/llnl/sundials/releases/download/v7.6.0/sundials-7.6.0.tar.gz"
  sha256 "0cb6f4bebd2ec13a42714a0654a58431d2cc473b759898b8e5fd8e1797c22712"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b051128524fb8b2c609e35b4449028196bc24613c499bd1110e0d49f54a6b9b3"
    sha256 cellar: :any,                 arm64_sequoia: "a8dc589a643e0381247a0b83d3084907b0ba7ee86e8403efc44fe29154d21694"
    sha256 cellar: :any,                 arm64_sonoma:  "6f2eb069ddfafcbb491cb8b17409c32f22a884308e22fa31c26b832f95ad4af0"
    sha256 cellar: :any,                 sonoma:        "fe7a35cecf06f0db23ead8ddba87ffae08166c2685354244ec584c964c54982f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82ca7dc8f48310ed5d19dc8b5b21ebf6d7d0884e820e7e0ce3a765f0056d32eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d4449de953ce1f0ffc1eb592e178c39a2ca7bbd192672edb2c467b969f9a30f"
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

    args += ["-I#{Formula["open-mpi"].opt_include}", "-L#{Formula["open-mpi"].opt_lib}"] if OS.mac?

    system ENV.cc, "test_nvector.c", "test_nvector_serial.c", "-o", "test", *args

    assert_match "SUCCESS: NVector module passed all tests", shell_output("./test 42 0")
  end
end
