class Sundials < Formula
  desc "Nonlinear and differential/algebraic equations solver"
  homepage "https://computation.llnl.gov/casc/sundials/main.html"
  url "https://computation.llnl.gov/projects/sundials/download/sundials-5.2.0.tar.gz"
  sha256 "95f058acce5bd66e654de65acdbb1c9f44c90cf1b4e28f8d933cdb4415ebba3e"
  revision 1

  bottle do
    cellar :any
    sha256 "1a4ba190408710f916d40b399fcbe2129a84bea08fe5abe5e590a3d9d5a2457c" => :catalina
    sha256 "646e9833b2d190b912c8ace6ccaa79d0f31b757c6eeae938156f7caca802ea5b" => :mojave
    sha256 "65aff1fc9d7ac97d198bb0dbd43afb420d77d3289093f2868c50d74e1087e5c8" => :high_sierra
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
