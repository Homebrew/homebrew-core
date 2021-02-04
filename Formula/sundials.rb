class Sundials < Formula
  desc "Nonlinear and differential/algebraic equations solver"
  homepage "https://computing.llnl.gov/projects/sundials"
  url "https://computing.llnl.gov/projects/sundials/download/sundials-5.7.0.tar.gz"
  sha256 "8d6dd094feccbb8d6ecc41340ec16a65fabac82ed4415023f6d7c1c2390ea2f3"
  license "BSD-3-Clause"

  livecheck do
    url "https://computation.llnl.gov/projects/sundials/sundials-software"
    regex(/href=.*?sundials[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "0fde980804a45806673fce03d868a090d38b8d1615b152dc8da3797f1d59054d"
    sha256 big_sur:       "eca818ac9876c5f784483f49eaeb6b8bb2a4a7950520f13e7dd99f43ad06d223"
    sha256 catalina:      "bacddf8c38b9c1236cd0aa2dc85273f7ffff6726418781f5a0e223bf132e3e07"
    sha256 mojave:        "9ad76e3dbc09c9d9cb4af9e600376fcae287c63128a100959871ddfe8dba438e"
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

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end

    # Only keep one example for testing purposes
    (pkgshare/"examples").install Dir[prefix/"examples/nvector/serial/*"] \
                                  - Dir[prefix/"examples/nvector/serial/{CMake*,Makefile}"]
    rm_rf prefix/"examples"
  end

  test do
    cp Dir[pkgshare/"examples/*"], testpath
    system ENV.cc, "-I#{include}", "test_nvector.c", "sundials_nvector.c",
                   "test_nvector_serial.c", "-L#{lib}", "-lsundials_nvecserial"
    assert_match "SUCCESS: NVector module passed all tests",
                 shell_output("./a.out 42 0")
  end
end
