class SuiteSparse < Formula
  desc "Suite of Sparse Matrix Software"
  homepage "http://faculty.cse.tamu.edu/davis/suitesparse.html"
  url "https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/v5.8.0.tar.gz"
  sha256 "94a9b7134eb4dd82b97f1a22a6b464feb81e73af2dcdf683c6f252285191df1d"

  bottle do
    cellar :any
    sha256 "a58c0cffed5bb4cdb5d4d8b91e2be407d3c0d2ad89bc000281374232c9de0b5d" => :catalina
    sha256 "c1c8fb4c8acddc05c8bc70c5fa687b7a9b4865922f97ebc91de15bd3e601e322" => :mojave
    sha256 "083961ebb0a6e06104384e33fd29bdbdec3eed273c9a1353b28308f80cae2f9d" => :high_sierra
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
