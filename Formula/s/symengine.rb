class Symengine < Formula
  desc "Fast symbolic manipulation library written in C++"
  homepage "https://sympy.org"
  # TODO: Check if we can use unversioned `llvm` at version bump.
  url "https://github.com/symengine/symengine/releases/download/v0.10.1/symengine-0.10.1.tar.gz"
  sha256 "9c007c99e9633f5549a55fa7a66ebcbcf9e04092eb55f7bb781c22b9cf0570c4"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4ea77c5ba66a825bb1ba2f6c93be7a806cd22dc741157f8286662d7de62a3d59"
    sha256 cellar: :any,                 arm64_ventura:  "b7de3d65c754f61b1e00b26dab6d356607ea596bcdf07d295a5ca6d20b2d9127"
    sha256 cellar: :any,                 arm64_monterey: "fa8597b8f74572776e248524a590d04a4228872d3d5625578d9034715e145aa8"
    sha256 cellar: :any,                 arm64_big_sur:  "453225c8cd6f3c8d70b8addf9ccd59319015e4cf348cba1d60ecd2f7a96b6003"
    sha256 cellar: :any,                 sonoma:         "bc4b7681c129c46c837e76b8309d666fa752d462d8086a756d30f244abcda249"
    sha256 cellar: :any,                 ventura:        "a7d87307e9641560a1c055b12d0e118c60363c4499541b1b2efc32c8de75acb4"
    sha256 cellar: :any,                 monterey:       "bedf50c1624699bf3fd2a2c82bfacf997080610a937ac058e7a7e1d48f4f79f1"
    sha256 cellar: :any,                 big_sur:        "d394fe9cb7dc8e28b78dbe4cf63e7b1728cb32778b385c3331e7312dda2c9fc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94b6334af9257858308b626b6050e08d95df7cba15ea94aa944ef0acbdb2cef9"
  end

  depends_on "cereal" => :build
  depends_on "cmake" => :build
  depends_on "flint"
  depends_on "gmp"
  depends_on "libmpc"
  depends_on "llvm@16"
  depends_on "mpfr"

  fails_with gcc: "5"

  # Avoid static linkage with LLVM. The static libraries contain
  # LTOed objects which causes errors with Apple's `ld`.
  # An alternative workaround is to use `lld` with `-fuse-ld=lld`.
  # TODO(carlocab): Upstream a version of this patch.
  patch do
    url "https://gitweb.gentoo.org/repo/gentoo.git/plain/sci-libs/symengine/files/symengine-0.8.1-fix_llvm.patch?id=83ab9587be9f89e667506b861208d613a2f016e5"
    sha256 "c654ea7c4ee44c689433e87f71c7ae78e6c04968e7dfe89be5e4ba4c8c53713b"
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
