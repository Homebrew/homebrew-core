class Sundials < Formula
  desc "Nonlinear and differential/algebraic equations solver"
  homepage "https://computation.llnl.gov/casc/sundials/main.html"
  url "https://computation.llnl.gov/projects/sundials/download/sundials-3.1.0.tar.gz"
  sha256 "18d52f8f329626f77b99b8bf91e05b7d16b49fde2483d3a0ea55496ce4cdd43a"
  revision 5

  bottle do
    cellar :any
    sha256 "f22fe0eae9cc77cb835c94f70e571cdb762f225f428086589d5f63973ae6cf42" => :high_sierra
    sha256 "bedad178ac24f40878453f97c077f277d82b76817918bed4238c9549f55cbda3" => :sierra
    sha256 "e9af5071822e9b90d4a2d78e0a218bddbf05e69db39037d360e7013000f7f5e7" => :el_capitan
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
