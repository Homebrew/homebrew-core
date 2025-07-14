class Symengine < Formula
  desc "Fast symbolic manipulation library written in C++"
  homepage "https://www.sympy.org/en/index.html"
  url "https://github.com/symengine/symengine/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "11c5f64e9eec998152437f288b8429ec001168277d55f3f5f1df78e3cf129707"
  license "MIT"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b413d0e962039cc33ce647e56b64d1e14e0485e9fb03aa9bb05c2a8815f2c77c"
    sha256 cellar: :any,                 arm64_sonoma:  "6cdebd7e58b3e36fd42c103b87205f01fa93b742dd6e9897c8395a8e4d4ab437"
    sha256 cellar: :any,                 arm64_ventura: "d7de7b5eaf7484feb69e980f635ca61f6122d08b7781f1e3a56fa61a25629147"
    sha256 cellar: :any,                 sonoma:        "c7029b46e1429bbb2a98812b47f4f6eb5f604b3fb6c660528b2d33ae536cd22c"
    sha256 cellar: :any,                 ventura:       "b4245f31edad7985f00376184b29ce8a724ffa572dc6fbc631474783e6831a8c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "683c421da7e1cd253c511bf8264c315a316ea55416c1b5ea2db0416337bab99c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08e4246b2c2aaf4cfc1924ffde3e4c4e4f787fdd72306d6eda1b0b922c213d39"
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
