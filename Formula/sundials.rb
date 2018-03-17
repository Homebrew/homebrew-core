class Sundials < Formula
  desc "Nonlinear and differential/algebraic equations solver"
  homepage "https://computation.llnl.gov/casc/sundials/main.html"
  url "https://computation.llnl.gov/projects/sundials/download/sundials-3.1.0.tar.gz"
  sha256 "18d52f8f329626f77b99b8bf91e05b7d16b49fde2483d3a0ea55496ce4cdd43a"
  revision 4

  bottle do
    cellar :any
    sha256 "e2bc6810a0668df7cd7c8e6ca78cafb1c97d449a008465d687408e732f3db964" => :high_sierra
    sha256 "0f9086f1325b34d99e9667af3d65218652d2d258ffa55d2415ab006bc1e7281e" => :sierra
    sha256 "82e828fe2506e43dbcd1e9f5e2095a1296d7cebec671f32f9f0bcd76dc7e0eab" => :el_capitan
  end

  option "with-openmp", "Enable OpenMP multithreading"
  option "without-mpi", "Do not build with MPI"

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "open-mpi" if build.with? "mpi"
  depends_on "suite-sparse"
  depends_on "veclibfort"

  fails_with :clang if build.with? "openmp"

  def install
    blas = "-L#{Formula["veclibfort"].opt_lib} -lvecLibFort"
    args = std_cmake_args + %W[
      -DCMAKE_C_COMPILER=#{ENV["CC"]}
      -DBUILD_SHARED_LIBS=ON
      -DKLU_ENABLE=ON
      -DKLU_LIBRARY_DIR=#{Formula["suite-sparse"].opt_lib}
      -DKLU_INCLUDE_DIR=#{Formula["suite-sparse"].opt_include}
      -DLAPACK_ENABLE=ON
      -DLAPACK_LIBRARIES=#{blas};#{blas}
    ]
    args << "-DOPENMP_ENABLE=ON" if build.with? "openmp"
    args << "-DMPI_ENABLE=ON" if build.with? "mpi"

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
