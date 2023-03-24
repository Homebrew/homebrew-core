class Symengine < Formula
  desc "Fast symbolic manipulation library written in C++"
  homepage "https://sympy.org"
  url "https://github.com/symengine/symengine/releases/download/v0.10.1/symengine-0.10.1.tar.gz"
  sha256 "9c007c99e9633f5549a55fa7a66ebcbcf9e04092eb55f7bb781c22b9cf0570c4"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7f3c867ef7955d3fb493fc5c0611a407ce6206c5bc66aa145abfde0ba5fe6492"
    sha256 cellar: :any,                 arm64_monterey: "053474e4925f7b4a9526df0fd4bd618848fe2b177cbbb1734e6a317e0a822c1e"
    sha256 cellar: :any,                 arm64_big_sur:  "3626c0ce21405e35146182bc58a421988c8feb104ab2cc6590c820fa49450aaa"
    sha256 cellar: :any,                 ventura:        "234f80764f1e2666ab7b18bc69e8f593d780174d15d777e353ea1532c93efdfa"
    sha256 cellar: :any,                 monterey:       "cb1f59e36fa69dced7ac91ba0cd5fd86715926b3d00a433491ebad1ca67f7e06"
    sha256 cellar: :any,                 big_sur:        "6cc101b8d049c2661ad3649a200b5483265732e49aa19d70f395e6e797f29ef9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6371e750145378cec5f9e6709120658bb74cada3a45a1a5fb85f4e52e0965cf8"
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
