class Sundials < Formula
  desc "Nonlinear and differential/algebraic equations solver"
  homepage "https://computation.llnl.gov/casc/sundials/main.html"
  url "https://computation.llnl.gov/projects/sundials/download/sundials-3.1.0.tar.gz"
  sha256 "18d52f8f329626f77b99b8bf91e05b7d16b49fde2483d3a0ea55496ce4cdd43a"

  bottle do
    cellar :any
    sha256 "e22f9416e3309857c71408e6a3062439a2d1da3a533221033373220e7d22c05c" => :high_sierra
    sha256 "3541a02039939d3335c012d116654d12a2fbdf4ad658f7f66cda7fde9331b0b3" => :sierra
    sha256 "a01431c6d358ffa85e1ffcb44653d298e3571319e3e77acd31bdf710d1c7af2f" => :el_capitan
  end

  option "with-openmp", "Enable OpenMP multithreading"

  depends_on "cmake" => :build
  depends_on "suite-sparse"
  depends_on "veclibfort"
  depends_on :fortran
  depends_on :mpi => [:cc, :f77, :recommended]

  needs :openmp if build.with?("openmp")

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
