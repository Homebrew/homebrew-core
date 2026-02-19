class SuiteSparse < Formula
  desc "Suite of Sparse Matrix Software"
  homepage "https://people.engr.tamu.edu/davis/suitesparse.html"
  url "https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/refs/tags/v7.12.2.tar.gz"
  sha256 "679412daa5f69af96d6976595c1ac64f252287a56e98cc4a8155d09cc7fd69e8"
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
    sha256                               arm64_tahoe:   "79e167c31cb17d1157e7a8ebad8acf1f78d35b2e9a470c6144f1a0863498e9f9"
    sha256                               arm64_sequoia: "44ec09106c538e4b149c48e96f493296372da13795b4871b14565bb0307f5e95"
    sha256                               arm64_sonoma:  "14901a3ce909aa7eb2ee0e5e3acf36f0bd1e1c7644e96c7176b7e556ab2033c7"
    sha256                               sonoma:        "3e193abe3edb85fd4b3d71dd576851713ed35609334a05dc1bd3ab1142ea0887"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a010fa4a7196e0f9f87df5b26918b0ad8c3454bfeeaeb30d3b2dff751d4f09f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "257a2b7d9c80846940af149b3b139ff6e77dbd4dd150c14d467ca751d9834910"
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
      libgomp = Formula["gcc"].opt_lib/"gcc/current/libgomp.dylib"
      lib.glob("*.dylib").map(&:realpath).uniq.each do |dylib|
        refute Utils.binary_linked_to_library?(dylib, libgomp), "Unwanted linkage to libgomp in #{dylib.basename}!"
      end
    end
  end
end
