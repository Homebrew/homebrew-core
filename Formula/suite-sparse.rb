class SuiteSparse < Formula
  desc "Suite of Sparse Matrix Software"
  homepage "http://faculty.cse.tamu.edu/davis/suitesparse.html"
  url "http://faculty.cse.tamu.edu/davis/SuiteSparse/SuiteSparse-5.4.0.tar.gz"
  sha256 "374dd136696c653e34ef3212dc8ab5b61d9a67a6791d5ec4841efb838e94dbd1"

  bottle do
    cellar :any
    sha256 "cd8f66c3e7358c6bb81f9e7975663283c605d057838bf74edafa21d5a9f55401" => :mojave
    sha256 "f3c2906bb5685a2c1a1c2702ec902b21dcbb41867a0962a8b161201a999200d2" => :high_sierra
    sha256 "f13c29af22afc7aef47694422b6c87f14a2645975e32789c72496fb96d2b1537" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "metis"
  depends_on "openblas"

  conflicts_with "mongoose", :because => "suite-sparse vendors libmongoose.dylib"

  def install
    mkdir "GraphBLAS/build" do
      system "cmake", "..", *std_cmake_args
    end

    args = [
      "INSTALL=#{prefix}",
      "BLAS=-L#{Formula["openblas"].opt_lib} -lopenblas",
      "LAPACK=$(BLAS)",
      "MY_METIS_LIB=-L#{Formula["metis"].opt_lib} -lmetis",
      "MY_METIS_INC=#{Formula["metis"].opt_include}",
    ]
    system "make", "library", *args
    system "make", "install", *args
    lib.install Dir["**/*.a"]
    pkgshare.install "KLU/Demo/klu_simple.c"
  end

  test do
    system ENV.cc, "-o", "test", pkgshare/"klu_simple.c",
           "-L#{lib}", "-lsuitesparseconfig", "-lklu"
    assert_predicate testpath/"test", :exist?
    assert_match "x [0] = 1", shell_output("./test")
  end
end
