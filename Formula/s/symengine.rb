class Symengine < Formula
  desc "Fast symbolic manipulation library written in C++"
  homepage "https://www.sympy.org/en/index.html"
  url "https://github.com/symengine/symengine/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "11c5f64e9eec998152437f288b8429ec001168277d55f3f5f1df78e3cf129707"
  license "MIT"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "df79e834fa3f34d24c03f89e336595fca313ac465697889dfaf8ed5d91d16dbf"
    sha256 cellar: :any,                 arm64_sonoma:  "e0662a8972639a72264fd3cc2d199e0b59a26f1b20675cb11082dd1b12ecf7ef"
    sha256 cellar: :any,                 arm64_ventura: "d380c1be286bcbfd0fe734a4b010d7235fe222cecaa925f55d08375844eb9e34"
    sha256 cellar: :any,                 sonoma:        "4e828156687bd21078763f13285a5198c6218ec4e0a8c9191d1ef93a32e5aca6"
    sha256 cellar: :any,                 ventura:       "ca02e12f3aa8b4a5a5dd312bd5d6270e690266c428f5b437ffbd657cb6b36f76"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1834d391bd9a7c56eeae26907398710c6b86ef8dd319dd3996ee0d66939185c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2542390b8ccd99af6c5957c75fd75e26908af774efcf59fe671b3bd7c1aa947"
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
