class SuiteSparse < Formula
  desc "Suite of Sparse Matrix Software"
  homepage "http://faculty.cse.tamu.edu/davis/suitesparse.html"
  url "https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/v5.7.2.tar.gz"
  sha256 "fe3bc7c3bd1efdfa5cffffb5cebf021ff024c83b5daf0ab445429d3d741bd3ad"

  bottle do
    cellar :any
    sha256 "5c3ce3ea482f6f46b7b012c21a1998a8eccb1b9261e6a06afe6b5900d2c55f19" => :catalina
    sha256 "cc77c74d00061555f536afa554d088395a75c405b364d1093c39122fbf2af352" => :mojave
    sha256 "1b9f2d0df61c59594115a70a1cafd849904244a1ac00cbdc7b7fc67b689cc69b" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "metis"
  depends_on "openblas"
  depends_on "tbb"

  uses_from_macos "m4"

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
