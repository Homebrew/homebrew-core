class SuiteSparse < Formula
  desc "Suite of Sparse Matrix Software"
  homepage "http://faculty.cse.tamu.edu/davis/suitesparse.html"
  url "https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/v5.7.1.tar.gz"
  sha256 "5ba5add1663d51a1b6fb128b50fe869b497f3096765ff7f8212f0ede044b9557"

  bottle do
    cellar :any
    sha256 "9d6feb2e2feb55df212703fd30a766676fa9e71f0ed9bdff49a120b9fe60396d" => :catalina
    sha256 "ce6d357d71455dc59dec5ec7e9739c6f8b6d981c6c0359eaf78df1308b0f246d" => :mojave
    sha256 "cb174cb7a53753f331d52422cf548262d014b26f7d50c0a13ff1141195b7d922" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "metis"
  depends_on "openblas"

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
