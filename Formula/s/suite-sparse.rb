class SuiteSparse < Formula
  desc "Suite of Sparse Matrix Software"
  homepage "https://people.engr.tamu.edu/davis/suitesparse.html"
  url "https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/refs/tags/v7.6.0.tar.gz"
  sha256 "19cbeb9964ebe439413dd66d82ace1f904adc5f25d8a823c1b48c34bd0d29ea5"
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
    sha256 cellar: :any,                 arm64_sonoma:   "2688af2a1ffe3f9f958846b60909954376c50e0bcaa53e42ee8d0832fd9c6ebb"
    sha256 cellar: :any,                 arm64_ventura:  "4d82f2cf8f443b3094161fcda646c2588dbe22182c89c5ad10849ad26ea2df9e"
    sha256 cellar: :any,                 arm64_monterey: "823276159d016f93b88e2ae568b87b080b343106230b9cfb8e7474638531459b"
    sha256 cellar: :any,                 sonoma:         "f776ed8d8c5b9092ae6be2f479df97d6fc94e822b81a60f73873a246d33ee90a"
    sha256 cellar: :any,                 ventura:        "21cb9e6ff61233fc0515e6119eca3aa9c25ff6f12ec8118620994e5f5912b372"
    sha256 cellar: :any,                 monterey:       "789aab765431c07810ece1c3cce13050190a8037e903f9f9cf2cfc58a7e6ba29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f58b475712619f02cc6665139a5ffd3f8e42cd80be40ee14fbb6b1624c387b6"
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
    if OS.mac?
      inreplace "GraphBLAS/cmake_modules/GraphBLAS_JIT_configure.cmake",
          "C_COMPILER_BINARY \"${CMAKE_C_COMPILER}\"", "C_COMPILER_BINARY \"#{ENV.cc}\""
    end

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
    assert_predicate testpath/"test", :exist?
    assert_match "x [0] = 1", shell_output("./test")
  end
end
