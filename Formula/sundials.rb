class Sundials < Formula
  desc "Nonlinear and differential/algebraic equations solver"
  homepage "https://computation.llnl.gov/casc/sundials/main.html"
  url "https://computation.llnl.gov/projects/sundials/download/sundials-5.1.0.tar.gz"
  sha256 "fb22d14fad42203809dc46d046b001149ec4e901b23882bd4a80619157fd9b21"
  revision 2

  bottle do
    cellar :any
    sha256 "ab5532fa4c5e2d26db2ffa858d21372d45f8732b4b0be423625d94db607c14a0" => :catalina
    sha256 "016a3fec880d65d7dc3f7f27add0c669c51031d0344e42249d3239a700e7fbdf" => :mojave
    sha256 "f82167f380abc2a54596529c8c549ab0730213e1da42374962d7a4f4f3ff6ee9" => :high_sierra
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
      -DCMAKE_C_COMPILER=#{ENV["CC"]}
      -DBUILD_SHARED_LIBS=ON
      -DKLU_ENABLE=ON
      -DKLU_LIBRARY_DIR=#{Formula["suite-sparse"].opt_lib}
      -DKLU_INCLUDE_DIR=#{Formula["suite-sparse"].opt_include}
      -DLAPACK_ENABLE=ON
      -DBLA_VENDOR=OpenBLAS
      -DLAPACK_LIBRARIES=#{blas};#{blas}
      -DMPI_ENABLE=ON
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    cp Dir[prefix/"examples/nvector/serial/*"], testpath
    system ENV.cc, "-I#{include}", "test_nvector.c", "sundials_nvector.c",
                   "test_nvector_serial.c", "-L#{lib}", "-lsundials_nvecserial"
    assert_match "SUCCESS: NVector module passed all tests",
                 shell_output("./a.out 42 0")
  end
end
