class Sundials < Formula
  desc "Nonlinear and differential/algebraic equations solver"
  homepage "https://computing.llnl.gov/projects/sundials"
  url "https://github.com/LLNL/sundials/releases/download/v6.5.0/sundials-6.5.0.tar.gz"
  sha256 "4e0b998dff292a2617e179609b539b511eb80836f5faacf800e688a886288502"
  license "BSD-3-Clause"

  livecheck do
    url "https://computing.llnl.gov/projects/sundials/sundials-software"
    regex(/href=.*?sundials[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d4eac42b39108ffd2d6ad67c2f61a891506287ba8fe282920a39e4a26fd4cc6c"
    sha256 cellar: :any,                 arm64_monterey: "9e706527e9de277e6e1e2553a316d87ec1b77843474366bb0ba3aa28f69db93b"
    sha256 cellar: :any,                 arm64_big_sur:  "c46baee5b2ab8fc59416b45f109a85ff39b0a84d2bbf0bec5a82c887967e9b35"
    sha256 cellar: :any,                 ventura:        "8c8eb69e931bcf9c2f90f2161f568422c35ecec7aef11ec65a27c62e30e89c92"
    sha256 cellar: :any,                 monterey:       "cf780c9529613ebe33362d145e92e73b0fd7f12cd07b398ff41c236bc3184d9f"
    sha256 cellar: :any,                 big_sur:        "ed8d574e91db4b17b9b245c6221e4f4f80bca50dee2aac8c718fee7551d2fb49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e6f1860244aaf30797b35bb5b1caf339f5fb725ba7274495944ae44cf6a5fa9"
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
