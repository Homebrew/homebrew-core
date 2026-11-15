class Symengine < Formula
  desc "Fast symbolic manipulation library written in C++"
  homepage "https://www.sympy.org/en/index.html"
  url "https://github.com/symengine/symengine/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "9f75f0367221abd88b9b60ef7b104b4aa1e34e99d3152c3df2bb2467bad2f04f"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "801a3d5fa8670387af7ca4064a773c004fa292b2668cff252175b15eaa2bce87"
    sha256 cellar: :any, arm64_tahoe:       "0c0cc9baa96d71eb7ef2434bc00acf7b0cef8156f800906125bc334c75685b26"
    sha256 cellar: :any, arm64_sequoia:     "8f95dff39598085208a6ee4d3c68e42ad58fe1c503c6a959315a9bc47f2b65ef"
    sha256 cellar: :any, arm64_linux:       "f2f2c1a6f048fa91634fe94e6ae84cff90cf3c8b5d796e422418c76ad7ba2ac7"
    sha256 cellar: :any, x86_64_linux:      "5b96941e248f25cd56e9ddd5da5c332df15a72b84659fc5b9135046bf8f43c0e"
  end

  depends_on "cereal" => :build
  depends_on "cmake" => :build
  depends_on "flint"
  depends_on "gmp"
  depends_on "libmpc"
  depends_on "llvm"
  depends_on "mpfr"

  deny_network_access!

  def install
    llvm = deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+)?$/) }
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DWITH_MPFR=ON",
                    "-DWITH_MPC=ON",
                    "-DINTEGER_CLASS=flint",
                    "-DWITH_LLVM=ON",
                    "-DCMAKE_UNITY_BUILD=ON",
                    "-DLLVM_DIR=#{llvm.opt_lib}/cmake/llvm",
                    "-DWITH_SYMENGINE_THREAD_SAFE=ON",
                    "-DWITH_SYSTEM_CEREAL=ON",
                    *std_cmake_args

    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <symengine/expression.h>
      using SymEngine::Expression;
      int main() {
        auto x=Expression('x');
        auto ex = x+sqrt(Expression(2))+1;
        auto equality = eq(ex+1, expand(ex));
        return equality == true;
      }
    CPP
    lib_flags = [
      "-L#{formula_opt_lib("gmp")}", "-lgmp",
      "-L#{formula_opt_lib("mpfr")}", "-lmpfr",
      "-L#{formula_opt_lib("flint")}", "-lflint"
    ]
    system ENV.cxx, "test.cpp", "-std=c++11", "-L#{lib}", "-lsymengine", *lib_flags, "-o", "test"

    system "./test"
  end
end
