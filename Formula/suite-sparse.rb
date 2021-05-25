class SuiteSparse < Formula
  desc "Suite of Sparse Matrix Software"
  homepage "https://people.engr.tamu.edu/davis/suitesparse.html"
  url "https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/v5.10.1.tar.gz"
  sha256 "acb4d1045f48a237e70294b950153e48dce5b5f9ca8190e86c2b8c54ce00a7ee"
  license all_of: [
    "BSD-3-Clause",
    "LGPL-2.1-or-later",
    "GPL-2.0-or-later",
    "Apache-2.0",
    "GPL-3.0-only",
    any_of: ["LGPL-3.0-or-later", "GPL-2.0-or-later"],
  ]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "b696334b2e85f808f161ad1d0e8b4761a35fd4cd602ad9191945052de8adf6c8"
    sha256 cellar: :any, big_sur:       "ec1ff22f589504c1b26b4365bba5288344e6d9a67a90e46d2328f3056e6c9927"
    sha256 cellar: :any, catalina:      "378a7ce83a05b3cbadd1e3b9d8fe6ffd53df581b6d5675c528cbd43345693b30"
    sha256 cellar: :any, mojave:        "5d95f7106ae3a79514c04a2fbc7a48434e2639cb06bbd5fa497b47c7b1ee998a"
  end

  depends_on "cmake" => :build
  depends_on "metis"
  depends_on "openblas"
  depends_on "tbb"

  uses_from_macos "m4"

  conflicts_with "mongoose", because: "suite-sparse vendors libmongoose.dylib"

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
