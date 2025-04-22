class SuiteSparse < Formula
  desc "Suite of Sparse Matrix Software"
  homepage "https://people.engr.tamu.edu/davis/suitesparse.html"
  url "https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/refs/tags/v7.10.2.tar.gz"
  sha256 "98ebd840a30ddd872b38879615b6045aa800d84eae6b44efd44b6b0682507630"
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
    sha256                               arm64_sequoia: "23972845c3198d20131fe22e03f4bedafc1771cefbc4bbc5a7511b2ced2f0c1d"
    sha256                               arm64_sonoma:  "c8d6e5b40e5cb69a05e0f57f04e807d9651261fd3b17fb3972eeab32e7ada10f"
    sha256                               arm64_ventura: "5c7789e5a358a13adfb4241626c594ee547ebeae42582184269a44c6aa78aa65"
    sha256                               sonoma:        "dee748034ca56f455d7bd714e8cf5a83c5522b60e3d270f4940d346d27f3142a"
    sha256                               ventura:       "18b21c1b1c6a74e7973d8fc12a2c1911e02fc1b892716e68f5d6c0c4604678dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81e38447e85694f4c133f09a3773aea9d9a95f4f379a80d7430cedd39a5c9e32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98ee10d5fca5d7b99b7e2178e68223ad6a744aabfd4e77474b016e2d582c3223"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "gmp"
  depends_on "metis"
  depends_on "mpfr"

  uses_from_macos "m4"

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
