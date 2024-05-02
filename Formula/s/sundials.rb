class Sundials < Formula
  desc "Nonlinear and differential/algebraic equations solver"
  homepage "https://computing.llnl.gov/projects/sundials"
  url "https://github.com/LLNL/sundials/releases/download/v7.0.0/sundials-7.0.0.tar.gz"
  sha256 "d762a7950ef4097fbe9d289f67a8fb717a0b9f90f87ed82170eb5c36c0a07989"
  license "BSD-3-Clause"

  livecheck do
    url "https://computing.llnl.gov/projects/sundials/sundials-software"
    regex(/href=.*?sundials[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7208f87472bd2536634aaaacfeaa580266003ef141510c62c0ea9401ff3d4a04"
    sha256 cellar: :any,                 arm64_ventura:  "bdfcea838f79480648789dd9349ad3502ec53c061d5ef8ffb06fe6798397fc49"
    sha256 cellar: :any,                 arm64_monterey: "f25cd67634fa31f63bef781c30d06eeebde0d003fab4b1473d64e360e80409da"
    sha256 cellar: :any,                 sonoma:         "9f3f553036bfade6369e0aed568bdfcd70ee014a633524be71cd964e92314c63"
    sha256 cellar: :any,                 ventura:        "5de190c8408154be40b2334dad1fc29a2b36bfb5137bb476492790d214405917"
    sha256 cellar: :any,                 monterey:       "c3187ac2f5810cf679310284d633f3279ca7482fb5d7cc8e3297b2e717a381eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b23b45865cf92bc32038125ccf7aa06b56a26cb048f1ef137c0d7350c89bcc03"
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
    (pkgshare/"examples").install Dir[prefix/"examples/nvector/serial/*"] \
                                  - Dir[prefix/"examples/nvector/serial/{CMake*,Makefile}"]
    (prefix/"examples").rmtree
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
