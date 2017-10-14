class Sundials < Formula
  desc "Nonlinear and differential/algebraic equations solver"
  homepage "https://computation.llnl.gov/casc/sundials/main.html"
  url "https://computation.llnl.gov/projects/sundials/download/sundials-2.7.0.tar.gz"
  sha256 "d39fcac7175d701398e4eb209f7e92a5b30a78358d4a0c0fcc23db23c11ba104"
  version "2.7.0"
  revision 2

  bottle do
    cellar :any
    sha256 "2bb4a32e13c6f88dc4abfd4e53f5694974081b1587c91029a58a9fb0d2764b5e" => :high_sierra
    sha256 "0f6752f78b608cfb6b380c7c474db0ab3bb797c6bef7991672fc794e3b835d81" => :sierra
    sha256 "b552a688e6eb08c71f721b8bddee4041e5f9a3ef55cb6be749d19a4fca9c9e25" => :el_capitan
    sha256 "f3926e8ecbd9601f519d96d451cdec60d23b33c3369cbeb82ca7ede1f3c190f4" => :yosemite
  end

  devel do
    url "https://computation.llnl.gov/projects/sundials/download/sundials-3.0.0-beta-2.tar.gz"
    sha256 "0e597707b4210dee9ab3583f072c2e5513b28cbbd8465296fc5c203074b225dd"
    version "3.0.0-beta-2"
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
