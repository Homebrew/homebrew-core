class SuiteSparse < Formula
  desc "Suite of Sparse Matrix Software"
  homepage "http://faculty.cse.tamu.edu/davis/suitesparse.html"
  url "http://faculty.cse.tamu.edu/davis/SuiteSparse/SuiteSparse-5.4.0.tar.gz"
  sha256 "374dd136696c653e34ef3212dc8ab5b61d9a67a6791d5ec4841efb838e94dbd1"

  bottle do
    cellar :any
    sha256 "5ea70a7540801f299739d12453031a99c711f5c749a519edb441ff00d33f0eef" => :mojave
    sha256 "3de3c42ad29f06ccdc510fef7189b1f795d91437b9263b81609c9e2e5fbd7d3c" => :high_sierra
    sha256 "e42fe827d11fafc90ce046ee4af2f0d30079db98576fbe03e186c38af6cf0ea6" => :sierra
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
