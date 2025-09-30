class Symengine < Formula
  desc "Fast symbolic manipulation library written in C++"
  homepage "https://www.sympy.org/en/index.html"
  url "https://github.com/symengine/symengine/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "11c5f64e9eec998152437f288b8429ec001168277d55f3f5f1df78e3cf129707"
  license "MIT"
  revision 4

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f5f3a894c1f8ebf1564f60f7bea8e02011d7cf229fe2b686d2cb468246e885aa"
    sha256 cellar: :any,                 arm64_sequoia: "a0cf67cc7e98d0210e0ad15eb15df2379d949bd235bc106e3035886e462f3c8a"
    sha256 cellar: :any,                 arm64_sonoma:  "08378ea3146241f35d24c636a298662accb539fbf4dfc8d87354f34121dc1564"
    sha256 cellar: :any,                 arm64_ventura: "d21da6676835e70716720ce60994aaa9da2572239190d2f81cc1a2d7cc998902"
    sha256 cellar: :any,                 sonoma:        "74f49611791f1f42a6a89327abe809ec350292208998da0477079f5d0e677ce0"
    sha256 cellar: :any,                 ventura:       "bb74c79619f0b9482f97e8c413706fb0453cd07cc4133d6fe6ee2cd9a6247b32"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6af631f2626d92e9c222e48cd4ef7ac1a1896ca66b881f333a5caaecb42adabf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5b4460a315a637f02f4c68f666ed15684418ceaef2c575e56c68a268987849f"
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
