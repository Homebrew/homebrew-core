class Symengine < Formula
  desc "Fast symbolic manipulation library written in C++"
  homepage "https://sympy.org"
  url "https://github.com/symengine/symengine/releases/download/v0.10.1/symengine-0.10.1.tar.gz"
  sha256 "9c007c99e9633f5549a55fa7a66ebcbcf9e04092eb55f7bb781c22b9cf0570c4"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "068f145d1f1cb87416969785f5b346dda3a22149b16cb941b7a9081cbfc6c286"
    sha256 cellar: :any,                 arm64_monterey: "85be7ed6a7211d22b62a38f79c0c62e97df0c6291858858c727ab56b5f58cc6c"
    sha256 cellar: :any,                 arm64_big_sur:  "834eb27d500386bb1ed2f59d719ced3e12271e840eb410defd329c2a898f26da"
    sha256 cellar: :any,                 ventura:        "f5d927e548ecc4451b6e8ff15e00f90028197b39cc69410a5f85a7ba691a7931"
    sha256 cellar: :any,                 monterey:       "e97e8b51cceee620ce781fd12c949f8550fe1fe209f30c1ea7fa8862d13dd50f"
    sha256 cellar: :any,                 big_sur:        "b630e8857dced409674f7b7d6106f854cd6ca4b67346012f990a8a24580d00f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8425f1dd5377f23b6dfd99ab8243f2315d987ad0151c6b56fd650a162a504eb1"
  end

  depends_on "cereal" => :build
  depends_on "cmake" => :build
  depends_on "flint"
  depends_on "gmp"
  depends_on "libmpc"
  depends_on "llvm"
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
