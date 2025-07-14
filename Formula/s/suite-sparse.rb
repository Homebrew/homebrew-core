class SuiteSparse < Formula
  desc "Suite of Sparse Matrix Software"
  homepage "https://people.engr.tamu.edu/davis/suitesparse.html"
  url "https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/refs/tags/v7.10.3.tar.gz"
  sha256 "09e7bcc8e5de0a5b55d2ae9fd6378d5f4dc1b85a933593339a0872b24e2cc102"
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
    sha256                               arm64_sequoia: "17e3905105eccbe9cc090941b651eda66ee6a72f6eba341b730e69cf96337de1"
    sha256                               arm64_sonoma:  "66689c5de3bf52ab8a7c01bc1018e775748325c29c889d71f3582a8194dfcc63"
    sha256                               arm64_ventura: "b754dbf20365a1baf955844246308101f312ae5e8ad08cd90b4a146b0a17dc71"
    sha256                               sonoma:        "4facf2d177821397d2b04f54cec3d4a0d14ce20963ae3b23cc82c342d511685e"
    sha256                               ventura:       "c335cdbd49c6fceeb0d2438c7ff1637d94d06b63647d9222b35598257cf92d8e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a8dc094c74c995bf7cc887b6cc270c123be9fd501b6657779c8a975b9a138df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b484a7475a7c907b153f18a88c187aba0a946f4088ba635c18d207b93fc75fcc"
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
