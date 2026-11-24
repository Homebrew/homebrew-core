class SuiteSparse < Formula
  desc "Suite of Sparse Matrix Software"
  homepage "https://people.engr.tamu.edu/davis/suitesparse.html"
  url "https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/refs/tags/v7.14.1.tar.gz"
  sha256 "81e560e1f74546df139edb765b3f5bc865866da23062312ffe8fd821063c8397"
  license all_of: [
    "BSD-3-Clause",
    "LGPL-2.1-or-later",
    "GPL-2.0-or-later",
    "Apache-2.0",
    "GPL-3.0-only",
    any_of: ["LGPL-3.0-or-later", "GPL-2.0-or-later"],
  ]
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    manifest_sha256 "249b722f763a46495ee908a83c78981e3c55e6074202967c984705eb9c62c1af"
    sha256               arm64_golden_gate: "3687826825b545464078a37d460a688d755a0de50b5a8d44cf32761d3b7a3053"
    sha256               arm64_tahoe:       "24fd62080d97f076644e233dde12b587a2ec1e0078ffd515dc391c82c96e7cc7"
    sha256               arm64_sequoia:     "40786ce8e8f632b4536bfd9970d4a3ff5f476cc79e482702875e982001b27d4b"
    sha256 cellar: :any, arm64_linux:       "968b1b4e76b0377ece9888becfd3b3abd8d19e6777eee5e50b34d7f089b78f13"
    sha256 cellar: :any, x86_64_linux:      "a31d90920987265a2621624b15a831d33ea4ac7eb68288c0397cef30dc3fa1cb"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "gmp"
  depends_on "mpfr"
  depends_on "openblas"

  on_macos do
    depends_on "libomp"
  end

  deny_network_access!

  def install
    # CMake FortranCInterface_VERIFY fails with LTO on Linux due to different GCC and GFortran versions
    ENV.append "FFLAGS", "-fno-lto" if OS.linux?

    # Avoid references to Homebrew shims
    inreplace "GraphBLAS/cmake_modules/GraphBLAS_JIT_configure.cmake",
              "C_COMPILER_BINARY \"${CMAKE_C_COMPILER}\"", "C_COMPILER_BINARY \"#{ENV.cc}\""

    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
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

    if OS.mac?
      # Avoid mixed OpenMP linkage
      require "utils/linkage"
      libgomp = formula_opt_lib("gcc")/"gcc/current/libgomp.dylib"
      lib.glob("*.dylib").map(&:realpath).uniq.each do |dylib|
        refute Utils.binary_linked_to_library?(dylib, libgomp), "Unwanted linkage to libgomp in #{dylib.basename}!"
      end
    end
  end
end
