class Symengine < Formula
  desc "Fast symbolic manipulation library written in C++"
  homepage "https://www.sympy.org/en/index.html"
  url "https://github.com/symengine/symengine/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "11c5f64e9eec998152437f288b8429ec001168277d55f3f5f1df78e3cf129707"
  license "MIT"
  revision 5

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "57800ea3d94e7eb3ec6443bd9ea982a88a40100f9ab923973a0fb8540205b8c2"
    sha256 cellar: :any,                 arm64_sequoia: "2bc7ffab436a6ad12e275e20c4d385092ac053929cfa435e9b8ab06e829f89ef"
    sha256 cellar: :any,                 arm64_sonoma:  "3c782fe53199f44bed129662e8617341ca1893226dc449a054335a166e179725"
    sha256 cellar: :any,                 sonoma:        "aa8e7c7d6984e8967cf4da933553d3973ed6cca1e4246956ffc493d8b8e1d73d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "867abc9ebb5f009dd86def716593d5554d8b89776ca71dd9c64366fbf089e5e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e60e6610384dc8bb9d2f45738ccbf733220c7d033072d42198963c1023c53ecf"
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
