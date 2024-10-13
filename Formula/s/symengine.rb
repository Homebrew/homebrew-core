class Symengine < Formula
  desc "Fast symbolic manipulation library written in C++"
  homepage "https://www.sympy.org/en/index.html"
  url "https://github.com/symengine/symengine/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "f46bcf037529cd1a422369327bf360ad4c7d2b02d0f607a62a5b09c74a55bb59"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ab15943b07b49eef917b3b107764f52fd7f8952e428a7b2af8a10241c4e58194"
    sha256 cellar: :any,                 arm64_sonoma:  "ced7720251ccbc29f375dd0f71133bfd1981c11ba3db7521536f3c0c6594db1f"
    sha256 cellar: :any,                 arm64_ventura: "e15d6d50c5d13cd087bff7e030bc8f18ebcab6241790977b022f7d00d6a562d5"
    sha256 cellar: :any,                 sonoma:        "ac919504afc4391b943682f3d582c133a9ff209a229cf7c2c92f0cf50809cb05"
    sha256 cellar: :any,                 ventura:       "a98d934c888a9aca724d592b54c40f3522c3f757245cfa1f9417e3508ebf9c2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4da25736de0ce6db3ae9ca178d5b0d421879dcc03bd83eaaa6d0920dd069e676"
  end

  depends_on "cereal" => :build
  depends_on "cmake" => :build
  depends_on "flint"
  depends_on "gmp"
  depends_on "libmpc"
  depends_on "llvm"
  depends_on "mpfr"
  depends_on "zstd"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_macos do
    depends_on "z3"
  end

  fails_with gcc: "5"

  def install
    llvm = deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+)?$/) }
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DWITH_GMP=ON",
                    "-DWITH_MPFR=ON",
                    "-DWITH_MPC=ON",
                    "-DINTEGER_CLASS=flint",
                    "-DWITH_LLVM=ON",
                    "-DWITH_COTIRE=OFF",
                    "-DLLVM_DIR=#{llvm.opt_lib}/cmake/llvm",
                    "-DWITH_SYMENGINE_THREAD_SAFE=ON",
                    "-DWITH_SYSTEM_CEREAL=ON",
                    *std_cmake_args

    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <symengine/expression.h>
      using SymEngine::Expression;
      int main() {
        auto x=Expression('x');
        auto ex = x+sqrt(Expression(2))+1;
        auto equality = eq(ex+1, expand(ex));
        return equality == true;
      }
    EOS
    lib_flags = [
      "-L#{Formula["gmp"].opt_lib}", "-lgmp",
      "-L#{Formula["mpfr"].opt_lib}", "-lmpfr",
      "-L#{Formula["flint"].opt_lib}", "-lflint"
    ]
    system ENV.cxx, "test.cpp", "-std=c++11", "-L#{lib}", "-lsymengine", *lib_flags, "-o", "test"

    system "./test"
  end
end
