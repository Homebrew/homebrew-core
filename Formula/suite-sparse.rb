class SuiteSparse < Formula
  desc "Suite of Sparse Matrix Software"
  homepage "http://faculty.cse.tamu.edu/davis/suitesparse.html"
  url "http://faculty.cse.tamu.edu/davis/SuiteSparse/SuiteSparse-4.5.6.tar.gz"
  sha256 "de5fb496bdc029e55955e05d918a1862a177805fbbd5b957e8b5ce6632f6c77e"

  bottle do
    cellar :any
    sha256 "c45c92b46ad9cc24bcb3179bc4991515277548a32cd9368a71acbda8a8a965b2" => :high_sierra
    sha256 "c99b1389e6b8fb5a34173abe4e1b64bd5ec19bd414f3b051b4706d304568625b" => :sierra
    sha256 "819cbbd30d6c791ce617e6109df9a533876b50b5b3e38e7a07910ba5d21713a4" => :el_capitan
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
