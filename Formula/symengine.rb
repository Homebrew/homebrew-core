class Symengine < Formula
  desc "Fast symbolic manipulation library written in C++"
  homepage "https://sympy.org"
  url "https://github.com/symengine/symengine/releases/download/v0.9.0/symengine-0.9.0.tar.gz"
  sha256 "dcf174ac708ed2acea46691f6e78b9eb946d8a2ba62f75e87cf3bf4f0d651724"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2f14a527a90815157ddd3a7050bce697084640bebadd38424d32f9303a94cffd"
    sha256 cellar: :any,                 arm64_big_sur:  "f243f842693a16ec33a24535420135944419434df3ff30b6763f6ccf72e1c8db"
    sha256 cellar: :any,                 monterey:       "9c1caba2abdaddcd60f3b12bae45abab47483fc9dd51c78775500045a58a39ce"
    sha256 cellar: :any,                 big_sur:        "f223805951efd1e98f0af0b981893891b6d81718f57a85843c807ef1b8dae2c4"
    sha256 cellar: :any,                 catalina:       "ef7f55776b013b964fc6da53ffe555251c782371d56ef4cb913d8368bbc43dd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9298e0d3a5074493f366481d4b2ab4ec65b8d12acc34bf3b47d301e02c26ad0e"
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
