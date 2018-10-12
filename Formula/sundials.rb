class Sundials < Formula
  desc "Nonlinear and differential/algebraic equations solver"
  homepage "https://computation.llnl.gov/casc/sundials/main.html"
  url "https://computation.llnl.gov/projects/sundials/download/sundials-3.2.0.tar.gz"
  sha256 "d2b690afecadf8b5a048bb27ab341de591d714605b98d3518985dfc2250e93f9"

  bottle do
    cellar :any
    sha256 "395df599c4b62d2db1cc65c1823b0711f7d4171f2bc41815354b9ec6a476409f" => :mojave
    sha256 "85d26a0fe45cc223074d986abfcdb70c06363a6cdbf5df8bff1f4f8a2ff7103d" => :high_sierra
    sha256 "9b679f316ad602b3b5057bb39a81b398f65bdae5fd7f80cb8d8ec3cba08cf7fa" => :sierra
    sha256 "2213f3ae580feabe0874cf229f39e9d9434cbaefe960f88616496a66a11512be" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "open-mpi"
  depends_on "suite-sparse"
  depends_on "veclibfort"

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
