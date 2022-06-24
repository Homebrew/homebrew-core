class Symengine < Formula
  desc "Fast symbolic manipulation library written in C++"
  homepage "https://sympy.org"
  url "https://github.com/symengine/symengine/releases/download/v0.9.0/symengine-0.9.0.tar.gz"
  sha256 "dcf174ac708ed2acea46691f6e78b9eb946d8a2ba62f75e87cf3bf4f0d651724"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5e75924cfebfe29c1ad56a211302098274dc7829e837d97ecce628998cc45012"
    sha256 cellar: :any,                 arm64_big_sur:  "d9aa2cf7d7fed7aa4fe3576e19e53dd595f3e43fe695c824a402487c0c56c82e"
    sha256 cellar: :any,                 monterey:       "cfdf4eceacd418168d86460b734e4af2f90d8a06a2b98a02610e2332637ab467"
    sha256 cellar: :any,                 big_sur:        "3b70d8cb61920a7d883af6f5c6d4f9ac90d0c2b7199d3f0499c3dd8c85790bf6"
    sha256 cellar: :any,                 catalina:       "846fa41a78303f48bc01a6f050b1af6a248ef6787d9d586994f4407747d32fe0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1728871d0ef9a14dea0a3478ea370f3cd2550a8738a95da7157919bbdc4d93f8"
  end

  depends_on "cmake" => :build
  depends_on "flint"
  depends_on "gmp"
  depends_on "libmpc"
  depends_on "llvm"
  depends_on "mpfr"

  fails_with gcc: "5"

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
