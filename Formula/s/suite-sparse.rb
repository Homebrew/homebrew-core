class SuiteSparse < Formula
  desc "Suite of Sparse Matrix Software"
  homepage "https://people.engr.tamu.edu/davis/suitesparse.html"
  url "https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/refs/tags/v7.14.0.tar.gz"
  sha256 "c552c4b4bb7d0978796e57263a73295bca0c6b41ad137b45b4f264cfe9300fcb"
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
    sha256               arm64_tahoe:   "a3b1dfaacedb759181afb0ad110c359a89b5c705f107a6d65243998e515b6cfe"
    sha256               arm64_sequoia: "57526f091043632c65fbcb851e716f6dc9febe7d81a81e044f1c1c6d16d4bb14"
    sha256               arm64_sonoma:  "4e1d912df4f1b2bae2c72b3f729f398b50e5593d24e10c070a3fdc5a3d08681e"
    sha256               sonoma:        "fdce115afffbd2eb6b871a6227a243d307fc5e340526f439aae3c93a899de5c7"
    sha256 cellar: :any, arm64_linux:   "ecafb6094f68b500f8bba9694e46432e8ef35334f2f7327df8557db3142c0ea0"
    sha256 cellar: :any, x86_64_linux:  "ebd703e7cb6a1e7af5704a0bc40020e67059f0989c8bb094b60e733f6f75b14f"
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
