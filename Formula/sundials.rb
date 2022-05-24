class Sundials < Formula
  desc "Nonlinear and differential/algebraic equations solver"
  homepage "https://computing.llnl.gov/projects/sundials"
  url "https://github.com/LLNL/sundials/releases/download/v6.2.0/sundials-6.2.0.tar.gz"
  sha256 "195d5593772fc483f63f08794d79e4bab30c2ec58e6ce4b0fb6bcc0e0c48f31d"
  license "BSD-3-Clause"

  livecheck do
    url "https://computing.llnl.gov/projects/sundials/sundials-software"
    regex(/href=.*?sundials[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0248e6a64c923dcc99d5751d8d313959ea92774ef8a912dc14ff37d84c5b7115"
    sha256 cellar: :any,                 arm64_big_sur:  "d59834d97421a6d811a478871279403ea74686759dee990bd949863d0a4fac37"
    sha256 cellar: :any,                 monterey:       "2ab855ce09480e3ad461ce5fc0dbe24900ba21d642a99f7920958d8ceab37c68"
    sha256 cellar: :any,                 big_sur:        "4b17d1f72023cbb2b6f4c961e4614eb62ae49c06b5695bf72be9286bbcc329a0"
    sha256 cellar: :any,                 catalina:       "ba6bc575e553aeb9379e638848c796e7b6607463cc47ebe30597338166ed7ff7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e12e3a78fee91e86116dbd16ad3f30e1871814ab5e3c5b2ef05af1ca68e89fe7"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "open-mpi"
  depends_on "openblas"
  depends_on "suite-sparse"

  uses_from_macos "libpcap"
  uses_from_macos "m4"

  def install
    blas = "-L#{Formula["openblas"].opt_lib} -lopenblas"
    args = std_cmake_args + %W[
      -DBUILD_SHARED_LIBS=ON
      -DKLU_ENABLE=ON
      -DKLU_LIBRARY_DIR=#{Formula["suite-sparse"].opt_lib}
      -DKLU_INCLUDE_DIR=#{Formula["suite-sparse"].opt_include}
      -DLAPACK_ENABLE=ON
      -DBLA_VENDOR=OpenBLAS
      -DLAPACK_LIBRARIES=#{blas};#{blas}
      -DMPI_ENABLE=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args
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
