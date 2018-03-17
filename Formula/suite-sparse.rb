class SuiteSparse < Formula
  desc "Suite of Sparse Matrix Software"
  homepage "http://faculty.cse.tamu.edu/davis/suitesparse.html"
  url "http://faculty.cse.tamu.edu/davis/SuiteSparse/SuiteSparse-5.2.0.tar.gz"
  sha256 "3c46c035ea8217649958a0f73360e825b0c9dcca4e32a9349d2c7678c0d48813"

  bottle do
    cellar :any
    sha256 "2d87260480f276e87774a09a24e634953357e5e42852300416535d1383d17cfb" => :high_sierra
    sha256 "accf1abe0b174630a5f41bac52d9ace961fd6a721f5b82961e70161ddddca5c2" => :sierra
    sha256 "b0d375015d7c8b96d06c03765f4d838b2045ca11d7381423d20131ba6bdd7ee4" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "metis"

  def install
    mkdir "GraphBLAS/build" do
      system "cmake", "..", *std_cmake_args
    end

    args = [
      "INSTALL=#{prefix}",
      "BLAS=-framework Accelerate",
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
    system "./test"
  end
end
