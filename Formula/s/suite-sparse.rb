class SuiteSparse < Formula
  desc "Suite of Sparse Matrix Software"
  homepage "https://people.engr.tamu.edu/davis/suitesparse.html"
  url "https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/refs/tags/v7.10.1.tar.gz"
  sha256 "9e2974e22dba26a3cffe269731339ae8e01365cfe921b06be6359902bd05862c"
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
    sha256                               arm64_sequoia: "edc57e8f5944b45e3e172cabc23fb7ec61535e98cf4b9e348424c63ff2a7cf6f"
    sha256                               arm64_sonoma:  "a5b128713a86dd599356d75a35fe2680c9e1afad3d00e26c3a54ec1cd44dfafc"
    sha256                               arm64_ventura: "67d3ff69f41235929b3d840cd61c2dbe75926e3eb677fb6d06683ef234b870a0"
    sha256                               sonoma:        "3f3983cd61fbd4a541cd3bc1f4f3e2b0a0ecaba613cdc8990fd4002465573428"
    sha256                               ventura:       "91d49e1773157869e8f9e18cc66c9ff81c1a1b04c0838df19283153866d1be01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34dd66fa93dff5055dbf84b1845fce216b8d03c8e4ce4154be3fc3dba5af608d"
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
    assert_path_exists testpath/"test"
    assert_match "x [0] = 1", shell_output("./test")
  end
end
