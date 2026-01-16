class SuiteSparse < Formula
  desc "Suite of Sparse Matrix Software"
  homepage "https://people.engr.tamu.edu/davis/suitesparse.html"
  url "https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/refs/tags/v7.12.1.tar.gz"
  sha256 "794ae22f7e38e2ac9f5cbb673be9dd80cdaff2cdf858f5104e082694f743b0ba"
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
    sha256                               arm64_tahoe:   "120c5a199e3771a98c8be0a3d621bf7a02e5a5b9f2b715d224e052f447f9b8c8"
    sha256                               arm64_sequoia: "ab1ff1fdd044d98f97fc239b8aef0292e3a47457dcc54131b3d284b16fbb8dfd"
    sha256                               arm64_sonoma:  "feba4ebc621cd24035a04e03a82498d56c37136f716df77c75351edd6f153b29"
    sha256 cellar: :any,                 sonoma:        "f41fa3af6f8e9956bf55fc41522523a2146637593d70ce7d9497d45f2d24d0ae"
    sha256                               arm64_linux:   "267c828851e333b9573c8b72823358bab9cafc5518a3aaedaad638a797bab89e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab36462e5c317a1636e0ad12873017d4cdf62476a69490130f8a977a69e33996"
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
    ENV["CC"] = "#{Formula["gcc"].opt_bin}/gcc-15"

    # Avoid references to Homebrew shims
    inreplace "GraphBLAS/cmake_modules/GraphBLAS_JIT_configure.cmake",
              "C_COMPILER_BINARY \"${CMAKE_C_COMPILER}\"", "C_COMPILER_BINARY \"#{ENV.cc}\""

    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", "-DCMAKE_C_COMPILER=#{ENV.cc}",
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
