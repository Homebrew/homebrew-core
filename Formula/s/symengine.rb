class Symengine < Formula
  desc "Fast symbolic manipulation library written in C++"
  homepage "https://sympy.org"
  # TODO: Check if we can use unversioned `llvm` at version bump.
  url "https://github.com/symengine/symengine/releases/download/v0.11.1/symengine-0.11.1.tar.gz"
  sha256 "217b39955dc19f920c6f54c057fdc89e8e155ddee8f0e3c3cacc67b3e3850b64"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "452da25ab2ac00b95aa885ae5e3f47169dc309f76afa0b662c2469032615b4af"
    sha256 cellar: :any,                 arm64_ventura:  "dcfec817fb0b4ac1bb455d7e880c4eb09202b2396ce2a3c5ee668dfdf7afe6fa"
    sha256 cellar: :any,                 arm64_monterey: "8726f63a9c1e49521d17b9b8ce0bf0a7b7522261ade102cc21b163ccb45b0533"
    sha256 cellar: :any,                 sonoma:         "52b05a062669c7d8dcbafbeb4fe8290a7e9100c5a2f1405e3146a76fa12309f7"
    sha256 cellar: :any,                 ventura:        "ae7957ea5a89e3b173380fde901a813221896ef5413fcdf7ca5634bcdf348de4"
    sha256 cellar: :any,                 monterey:       "cf73ccf03218d5fef43a2746afddff296fac3b162ea8e71c9caf3dae5b4c43a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b87ca38ef53f35491afab8bb022f034681d2a5b5dacef31c692c8412abbdfdd"
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
