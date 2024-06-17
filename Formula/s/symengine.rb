class Symengine < Formula
  desc "Fast symbolic manipulation library written in C++"
  homepage "https://www.sympy.org/en/index.html"
  url "https://github.com/symengine/symengine/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "1b5c3b0bc6a9f187635f93585649f24a18e9c7f2167cebcd885edeaaf211d956"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d2ab56021bd2a124b559a41a213cad940fd883a3869af2d01361b94b7fd3bd6b"
    sha256 cellar: :any,                 arm64_ventura:  "1e9bd2a99176dc1fd9476ed304dc9b21e8a0f3bf323a4a09c01dd046aad21d4f"
    sha256 cellar: :any,                 arm64_monterey: "99f948cca1c0144a48902ec86106aeb9473862e8cfce1063fbe2714dff3aeb5f"
    sha256 cellar: :any,                 sonoma:         "ee58982edf91d2a315962e5a1782b8cd9370e0c52e01ef961bfaa22bd083fba1"
    sha256 cellar: :any,                 ventura:        "8c08e8dff2ec75f71a1a8be955460a4e270d15d3120470514aca14eeec199900"
    sha256 cellar: :any,                 monterey:       "96dd0c2c05e1cad567ec5acd6eada34cbe10984b10ef8f002076d0692786ffae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e567a13b598d649e018ee63905d33563f10bbd22b81ad370289e2a7cd78d66e0"
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
