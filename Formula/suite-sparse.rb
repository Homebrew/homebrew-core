class SuiteSparse < Formula
  desc "Suite of Sparse Matrix Software"
  homepage "http://faculty.cse.tamu.edu/davis/suitesparse.html"
  url "http://faculty.cse.tamu.edu/davis/SuiteSparse/SuiteSparse-5.1.2.tar.gz"
  sha256 "4ec8d344bd8e95b898132ddffd7ee93bfbb2c1224925d11bab844b08f9b4c3b7"

  bottle do
    cellar :any
    sha256 "541d22d94ddcd237368883c891d7457c2b41c855ae10ce775354552f2dbff896" => :high_sierra
    sha256 "f8b7d69319110184afedf314c52d1fc8a26fa7c53bfe61c48351847798747589" => :sierra
    sha256 "5a2be932d3950d6c2e06d3fa8eab50eb89c40cee6aede977dbfc6f0eb586772a" => :el_capitan
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
