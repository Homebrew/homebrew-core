class SuiteSparse < Formula
  desc "Suite of Sparse Matrix Software"
  homepage "http://faculty.cse.tamu.edu/davis/suitesparse.html"
  url "http://faculty.cse.tamu.edu/davis/SuiteSparse/SuiteSparse-5.3.0.tar.gz"
  sha256 "90e69713d8c454da5a95a839aea5d97d8d03d00cc1f667c4bdfca03f640f963d"

  bottle do
    cellar :any
    sha256 "ce3bbe3bc921e56751cf3c16308aca835d4e469229f9c701c5a55d88e345015f" => :high_sierra
    sha256 "383431c30941920ae76418025da663c6795ce3360925dc5644c2c5d505b33ec7" => :sierra
    sha256 "080a1b7292deb21297e00e112e6836e20006a3eaca67972d8c0d176092604347" => :el_capitan
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
