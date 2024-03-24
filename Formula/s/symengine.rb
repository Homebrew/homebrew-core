class Symengine < Formula
  desc "Fast symbolic manipulation library written in C++"
  homepage "https://sympy.org"
  url "https://github.com/symengine/symengine/releases/download/v0.11.2/symengine-0.11.2.tar.gz"
  sha256 "f6972acd6a65354f6414e69460d2e175729470632bdac05919bc2f7f32e48cbd"
  license "MIT"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6458bc2c2e3337c318d7fc2857c0034c013c29512ffee81def43db6c97f3c732"
    sha256 cellar: :any,                 arm64_ventura:  "24c2d6c14123358e039800c9b674a7498e6c56717c7eeec4cf47b10b410f1755"
    sha256 cellar: :any,                 arm64_monterey: "6db2af1d4df294e5bfde8c9778f03e93d11e828f64561c0ad43f6dfc89fc06c5"
    sha256 cellar: :any,                 sonoma:         "4c852b02a1579c981b4f29c3a115f562846158d6f1fd8956170100455c929db1"
    sha256 cellar: :any,                 ventura:        "4df7e9b3f04f1786c6e105c0839ea130a6dce4bc8cc406ac3b70cdcf40c2c95c"
    sha256 cellar: :any,                 monterey:       "4ccf43a756805df78e3c9b7f4e9580dfa26fb4901a045e88b586f35d3669962e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8746a70d6068a6209161bd7780fb42e103a3277dffd08dd8d7f080e9738bea21"
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

  # LLVM 18 support
  # remove at next release
  patch do
    url "https://github.com/symengine/symengine/commit/b3b9b43d3ecb387664223bb08bb7511f4f5fa548.patch?full_index=1"
    sha256 "09574aba1efcd2bfeb12deb4dc786d41d42a48c613e2ee6f829fec0f1bf92391"
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
