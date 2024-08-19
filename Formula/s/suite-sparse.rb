class SuiteSparse < Formula
  desc "Suite of Sparse Matrix Software"
  homepage "https://people.engr.tamu.edu/davis/suitesparse.html"
  url "https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/refs/tags/v7.8.1.tar.gz"
  sha256 "b645488ec0d9b02ebdbf27d9ae307f705de2b6133edb64617a72c7b4c6c3ff44"
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
    sha256                               arm64_sonoma:   "a6aa6d3e5872189dcf89d558a4fcdddca4a92bb26a1b20779838c60c525ac71f"
    sha256                               arm64_ventura:  "59c1a10757d52ee5e7b51e19112551ebcca96188ab7cdb3bf05377b91eeb5059"
    sha256                               arm64_monterey: "c906c694ef6d9690dc27d09ac3baff0e86c08a1c6ac70e7b4e7208f17a47ec12"
    sha256                               sonoma:         "f0a14d1280d214b605c81e9a15c00b981488459a4e8ad92d9697d54352fc6fae"
    sha256                               ventura:        "099cab1ad5fa3220e260995f3cf7301a24005d5342beb0bfde3f80ded0114faf"
    sha256                               monterey:       "6f2d1e3b8cdba689c0820556880bc199401c77c36154c58b084f9b2deeb58898"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60c0d73251c583c3f771b579e765cf93f79c254fde83c877884f3ab85fa86197"
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
