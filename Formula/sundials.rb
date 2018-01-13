class Sundials < Formula
  desc "Nonlinear and differential/algebraic equations solver"
  homepage "https://computation.llnl.gov/casc/sundials/main.html"
  url "https://computation.llnl.gov/projects/sundials/download/sundials-3.1.0.tar.gz"
  sha256 "18d52f8f329626f77b99b8bf91e05b7d16b49fde2483d3a0ea55496ce4cdd43a"
  revision 3

  bottle do
    cellar :any
    sha256 "60a049ed8478e7aabdd777bd3a10a35ee4576b2274af71e35ebb90561ea1fcd1" => :high_sierra
    sha256 "5ad8d501c86179ec95e2bcef6a040c1692989b69be9cd2d865cb0830fa094865" => :sierra
    sha256 "b23c4f2baafe75e67b647ed57c77098e883f23eef63796c37507b4276b28cf82" => :el_capitan
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
