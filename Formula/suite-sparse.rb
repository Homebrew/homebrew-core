class SuiteSparse < Formula
  desc "Suite of Sparse Matrix Software"
  homepage "http://faculty.cse.tamu.edu/davis/suitesparse.html"
  url "http://faculty.cse.tamu.edu/davis/SuiteSparse/SuiteSparse-4.5.6.tar.gz"
  sha256 "de5fb496bdc029e55955e05d918a1862a177805fbbd5b957e8b5ce6632f6c77e"

  bottle do
    cellar :any
    sha256 "9a68eb77f9488be393428952f76d7626a3fe3b9659713c74a263cacc67bc9eb7" => :high_sierra
    sha256 "04927e85ebcc7a550d399b39cb773206e380b3d26ddb1d35f4d2e6f88e6f36ea" => :sierra
    sha256 "df8fa69e0bedbce60be7de8c19a5164eadf51f3bdf31dc1561c2edd688a9ad2e" => :el_capitan
    sha256 "cf849ee340a48be83e92ed588bf66cc9f0f817978dd147456ff7186fbf39d5a8" => :yosemite
  end

  depends_on "metis"

  def install
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
