class SuiteSparse < Formula
  desc "Suite of Sparse Matrix Software"
  homepage "https://people.engr.tamu.edu/davis/suitesparse.html"
  url "https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/refs/tags/v7.7.0.tar.gz"
  sha256 "529b067f5d80981f45ddf6766627b8fc5af619822f068f342aab776e683df4f3"
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
    sha256 cellar: :any,                 arm64_sonoma:   "e6229acfa28e083373801cdc71cbc50e0639a817f1a515558176dd5932f03c56"
    sha256 cellar: :any,                 arm64_ventura:  "765d5056333a36a18912354f1f25ea1c45cc0f48cda9afcf4beaffb9b3240118"
    sha256 cellar: :any,                 arm64_monterey: "7a7345e4fd7e91c2d876f14b6ec4fa7639e103570c69035b6ee826999b9c8ff6"
    sha256 cellar: :any,                 sonoma:         "5d35a5e4b5f85f47d85dd631b09c7c636403d0988537cb30d0af488c4d2a415e"
    sha256 cellar: :any,                 ventura:        "64b324938ea324f0a42e167991ea39da46c4d24312aca7be6ff860f06a0c2364"
    sha256 cellar: :any,                 monterey:       "76053ed3b54df0ffc28d71c9c1c8a44000b8b86f4157d026f552650213c429b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c3ba212f0d9fee64c37fa0052e76b9daf15519951eabc70898c77eec3eb7be1"
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
