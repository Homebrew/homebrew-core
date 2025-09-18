class SuiteSparse < Formula
  desc "Suite of Sparse Matrix Software"
  homepage "https://people.engr.tamu.edu/davis/suitesparse.html"
  url "https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/refs/tags/v7.11.0.tar.gz"
  sha256 "93ed4c4e546a49fc75884c3a8b807d5af4a91e39d191fbbc60a07380b12a35d1"
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
    sha256                               arm64_tahoe:   "1ecf096ad33ac762eb745bc3fd2dc8dd836140827effd5603a56ef3c22a3c9c0"
    sha256                               arm64_sequoia: "ceeed1f94c9f421e9d6899fe7967f8789ff00018a0cd7393eda790369a270997"
    sha256                               arm64_sonoma:  "0bee9c1624927fa5a9ae3fd4ef09d6b9f5295dde255cbe6084bf4455e1c34f20"
    sha256                               arm64_ventura: "d8dc9f85929925f774adcb7923c9be250465f3cf56b59f7e1f93951b2353d184"
    sha256                               sonoma:        "d17e1f63a48010491d52b47bc65dcbd4cb2f9ca701835984cba60a9d02d09327"
    sha256                               ventura:       "2d756bf83971989982e0345d60c1188a1542bb0bfeff88f5d1793e73c8775a06"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2fe030d75cb79c6c6428595df9ed602ec3cbc3b9956af10c58a8e92f19f8421"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0301f655844671472214972870de180f3c96384c6e91d81517a1dd5faa9c71a"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "gmp"
  depends_on "mpfr"

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "openblas"
  end

  def install
    # Avoid references to Homebrew shims
    inreplace "GraphBLAS/cmake_modules/GraphBLAS_JIT_configure.cmake",
              "C_COMPILER_BINARY \"${CMAKE_C_COMPILER}\"", "C_COMPILER_BINARY \"#{ENV.cc}\""

    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}",
                                              *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "KLU/Demo/klu_simple.c"
  end

  test do
    system ENV.cc, "-o", "test", pkgshare/"klu_simple.c",
                   "-I#{include}/suitesparse", "-L#{lib}",
                   "-lsuitesparseconfig", "-lklu"
    assert_path_exists testpath/"test"
    assert_match "x [0] = 1", shell_output("./test")
  end
end
