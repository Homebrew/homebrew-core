class Symengine < Formula
  desc "Fast symbolic manipulation library written in C++"
  homepage "https://sympy.org"
  url "https://github.com/symengine/symengine/releases/download/v0.9.0/symengine-0.9.0.tar.gz"
  sha256 "dcf174ac708ed2acea46691f6e78b9eb946d8a2ba62f75e87cf3bf4f0d651724"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "abe08332bac543566383c8db4f39281f000af279aa0dc49f8ba270f6c2575aba"
    sha256 cellar: :any,                 arm64_big_sur:  "7326b614f16bfe94f168093b138f8a5ea64d1c26375edc80494c14b2f71919d9"
    sha256 cellar: :any,                 monterey:       "da5f894beea834d4736105580d896218e62e470e3af4004f46bbdeabf94415e8"
    sha256 cellar: :any,                 big_sur:        "8797e85c5af2516586b9b2fd3c8510dc714616e08642dff3d9fa6cf49fc969da"
    sha256 cellar: :any,                 catalina:       "99ef93943b81e12248e9ccc1ae8cd391e28802915ce86567e67b49986efb0a9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c6191c7d326ae878fde11604f09887c7b5a6b7aa579755cfc0b4672b752afdb"
  end

  depends_on "cmake" => :build
  depends_on "flint"
  depends_on "gmp"
  depends_on "libmpc"
  depends_on "llvm"
  depends_on "mpfr"

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DWITH_GMP=ON",
                    "-DWITH_MPFR=ON",
                    "-DWITH_MPC=ON",
                    "-DINTEGER_CLASS=flint",
                    "-DWITH_LLVM=ON",
                    "-DWITH_COTIRE=OFF",
                    "-DLLVM_DIR=#{Formula["llvm"].opt_lib}/cmake/llvm",
                    "-DWITH_SYMENGINE_THREAD_SAFE=ON",
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
