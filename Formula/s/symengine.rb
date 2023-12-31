class Symengine < Formula
  desc "Fast symbolic manipulation library written in C++"
  homepage "https://sympy.org"
  url "https://github.com/symengine/symengine/releases/download/v0.11.2/symengine-0.11.2.tar.gz"
  sha256 "f6972acd6a65354f6414e69460d2e175729470632bdac05919bc2f7f32e48cbd"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e19eca46111227cab7806c4a7b408a07230a1148afc05004e761c4b564d806d7"
    sha256 cellar: :any,                 arm64_ventura:  "490dcf93e8704e3126995834b16431892ff946dd6c164059b5cafd800fdd344a"
    sha256 cellar: :any,                 arm64_monterey: "2fec206eec63cbe5cdb9e4e94ae23adf17e320aaeda1a7f65b3ad1e147e60b0e"
    sha256 cellar: :any,                 sonoma:         "e3dc3e24c7c722fd8fada1a856134df934f55f12311c782759353c673cc797ea"
    sha256 cellar: :any,                 ventura:        "bbf4516e06744a99504a9e1d5335c1d175d8bbe3828299618ee0c7eae8fb0da6"
    sha256 cellar: :any,                 monterey:       "6d1b8080812a5c93ad6d2144afa86d2c863eb8e151ea4151338a321fc6241d61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6324f6ebd3228690258d256d9068ece631dd09283f976d64d911b639f504db3a"
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
