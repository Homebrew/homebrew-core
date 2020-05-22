class Sundials < Formula
  desc "Nonlinear and differential/algebraic equations solver"
  homepage "https://computation.llnl.gov/casc/sundials/main.html"
  url "https://computation.llnl.gov/projects/sundials/download/sundials-5.3.0.tar.gz"
  sha256 "88dff7e11a366853d8afd5de05bf197a8129a804d9d4461fb64297f1ef89bca7"

  bottle do
    cellar :any
    sha256 "09aeb5e0b4d6aac87785626f133b5fe25118dc9c9d163551dd46ce730f66c481" => :catalina
    sha256 "89fabca832a6aa0b3017b2c7252beb2e6cb8955358c975d99fdb063c39a7291b" => :mojave
    sha256 "54784d6070e0d0eddfda4258992085d0b6ef3c683d26539c04f0f8a85ebdb9ef" => :high_sierra
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
      -DCMAKE_C_COMPILER=/usr/bin/clang
      -DCMAKE_CXX_COMPILER=/usr/bin/clang++
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
