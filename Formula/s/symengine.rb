class Symengine < Formula
  desc "Fast symbolic manipulation library written in C++"
  homepage "https://www.sympy.org/en/index.html"
  url "https://github.com/symengine/symengine/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "9f75f0367221abd88b9b60ef7b104b4aa1e34e99d3152c3df2bb2467bad2f04f"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a95aa5994dbc12d8dba411d71d064834a65120359ce43e8cc70ab907e04ba0c3"
    sha256 cellar: :any, arm64_sequoia: "6a60f10375dea781b228d21898563abcf2c247fb2ac75f21eac372ece1474230"
    sha256 cellar: :any, arm64_sonoma:  "09b0f8531c31f92d1feb8add85b1b53d941ea38633338da13b06918c1b5a651d"
    sha256 cellar: :any, sonoma:        "c4fc53287a57a5a23e52c28a26b34d3818cc26f3ea072b6c343834c811d50e64"
    sha256 cellar: :any, arm64_linux:   "216e2f5564764584390b62942da76dec4963ebba7a95ccbd8472b0345eb8312b"
    sha256 cellar: :any, x86_64_linux:  "9c27f6c21daef3545a662a2da1ea3572b126037eed8fd623dc3021ebb3001fff"
  end

  depends_on "cereal" => :build
  depends_on "cmake" => :build
  depends_on "flint"
  depends_on "gmp"
  depends_on "libmpc"
  depends_on "llvm"
  depends_on "mpfr"

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
