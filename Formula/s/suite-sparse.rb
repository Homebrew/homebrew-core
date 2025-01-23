class SuiteSparse < Formula
  desc "Suite of Sparse Matrix Software"
  homepage "https://people.engr.tamu.edu/davis/suitesparse.html"
  url "https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/refs/tags/v7.8.3.tar.gz"
  sha256 "ce39b28d4038a09c14f21e02c664401be73c0cb96a9198418d6a98a7db73a259"
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
    sha256                               arm64_sequoia: "b3be4466aad46989c1d9eed2186c9d9aa78d3b74e23f6cf24fce800137971008"
    sha256                               arm64_sonoma:  "b1d17e11272fe3812f316a4ee000aae8ea965651191112f97d810abfeffc1cb4"
    sha256                               arm64_ventura: "d29bad2907d1bae7f44ed975a881134c41c87174545b67ce2fad454829e944ed"
    sha256                               sonoma:        "41c4267660a34693c857e3fd72d296a053efd3cbe727e08b6cbdb82c8504472a"
    sha256                               ventura:       "ff7eadebe8c167bb4018d07285929e8d9429383169138a72b51d69ea81bf1d7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2fac51e98f64e011d40a02a3f0ef52536f25089ad00c2989f47c61e671887b04"
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
