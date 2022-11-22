class Symengine < Formula
  desc "Fast symbolic manipulation library written in C++"
  homepage "https://sympy.org"
  url "https://github.com/symengine/symengine/releases/download/v0.9.0/symengine-0.9.0.tar.gz"
  sha256 "dcf174ac708ed2acea46691f6e78b9eb946d8a2ba62f75e87cf3bf4f0d651724"
  license "MIT"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5e9da40908b2b1a4dd09e1d150db04c1fea72ede228e5df81cb4ba7fd699b48c"
    sha256 cellar: :any,                 arm64_monterey: "a21f1ecb176e2381decdbc6571f59541f496d6a0e051830e30580efec1243a48"
    sha256 cellar: :any,                 arm64_big_sur:  "5761bf631464fe6891de913a4f96804a5b40a90bbe419dc3887b25d9f155c58e"
    sha256 cellar: :any,                 ventura:        "e653de90c0bf275adcdfe257ba6dd4891c226eff6a1782bf6ef4d25ca007b446"
    sha256 cellar: :any,                 monterey:       "8af8b961cbd4dec429440094b7dc5dea18ff766682f013b915d2688497ccc626"
    sha256 cellar: :any,                 big_sur:        "db330d18c95e408e3ad4ae1496cedc00313218fe08a11c8f5590e27d9016af81"
    sha256 cellar: :any,                 catalina:       "6a0483496434c4d7205a05295db8862d068c92c2e6c7c92cb0dbafeb147d3fc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f113390949772bbe3514e1a7e49c78a29c9e3f2fae7dbac59415b06bf5b2a58b"
  end

  depends_on "cmake" => :build
  depends_on "cereal"
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
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DWITH_GMP=ON",
                    "-DWITH_MPFR=ON",
                    "-DWITH_MPC=ON",
                    "-DINTEGER_CLASS=flint",
                    "-DWITH_LLVM=ON",
                    "-DWITH_COTIRE=OFF",
                    "-DLLVM_DIR=#{Formula["llvm"].opt_lib}/cmake/llvm",
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
