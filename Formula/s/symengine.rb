class Symengine < Formula
  desc "Fast symbolic manipulation library written in C++"
  homepage "https://www.sympy.org/en/index.html"
  url "https://github.com/symengine/symengine/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "11c5f64e9eec998152437f288b8429ec001168277d55f3f5f1df78e3cf129707"
  license "MIT"
  revision 5

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "e243f21786ba3bc3805f8380e945326946a3ffac29c12687dd502db5a94e4f01"
    sha256 cellar: :any,                 arm64_sequoia: "a0acada4f3c463042fc246aa4639e0766985e7752672866b1f6ac3709eb7cc76"
    sha256 cellar: :any,                 arm64_sonoma:  "fc4e06c10863cb7622deff1930039588f85e36707815bd07dd0f7c08148ff27e"
    sha256 cellar: :any,                 sonoma:        "94ccb5e8ee69a585599c0eff75027a8d94832c866489c2a803ab166a1ee54fe6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4fbb496d756a6433d29ec226bfcf8ecda59eea22a2d8960e356480f88acb8396"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac61e019a0c4f7ec72371bea505bc48fb9d20d43ff61e87b332c147fba63f1c2"
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

  on_macos do
    depends_on "z3"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
      "-L#{Formula["gmp"].opt_lib}", "-lgmp",
      "-L#{Formula["mpfr"].opt_lib}", "-lmpfr",
      "-L#{Formula["flint"].opt_lib}", "-lflint"
    ]
    system ENV.cxx, "test.cpp", "-std=c++11", "-L#{lib}", "-lsymengine", *lib_flags, "-o", "test"

    system "./test"
  end
end
