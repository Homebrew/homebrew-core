class SuiteSparse < Formula
  desc "Suite of Sparse Matrix Software"
  homepage "http://faculty.cse.tamu.edu/davis/suitesparse.html"
  url "http://faculty.cse.tamu.edu/davis/SuiteSparse/SuiteSparse-5.4.0.tar.gz"
  sha256 "374dd136696c653e34ef3212dc8ab5b61d9a67a6791d5ec4841efb838e94dbd1"
  revision 1

  bottle do
    cellar :any
    sha256 "084ddd8dce513563655e5669735e04c98d6bd943733cafbc5d95e1f8e8e008d8" => :mojave
    sha256 "8b35538d0cf72b43c7be15a3d4ab2f1daa66dc05990f7d5237fc9f91d6d4e05f" => :high_sierra
    sha256 "c318dd0df8749f62f14b16d3e256fdbaf242338be99ecc9434cf7e316545b651" => :sierra
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
