class Sundials < Formula
  desc "Nonlinear and differential/algebraic equations solver"
  homepage "https://computation.llnl.gov/casc/sundials/main.html"
  url "https://computation.llnl.gov/projects/sundials/download/sundials-3.1.1.tar.gz"
  sha256 "a24d643d31ed1f31a25b102a1e1759508ce84b1e4739425ad0e18106ab471a24"
  revision 1

  bottle do
    cellar :any
    sha256 "2d29de827678a50195736e9ca2eeca299348414fda265bf98ef36a3c6ba46256" => :high_sierra
    sha256 "868b637ef5abdfdc3662e13f7967c2cdbe343ced8c07a6abfa165f94fd5854f1" => :sierra
    sha256 "1ff1f7e43e058be144373ef165b2cc41f4889fb070fb82794f9341d69e3580c9" => :el_capitan
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
