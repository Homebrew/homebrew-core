class Symengine < Formula
  desc "Fast symbolic manipulation library written in C++"
  homepage "https://www.sympy.org/en/index.html"
  url "https://github.com/symengine/symengine/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "11c5f64e9eec998152437f288b8429ec001168277d55f3f5f1df78e3cf129707"
  license "MIT"
  revision 8

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a95aa5994dbc12d8dba411d71d064834a65120359ce43e8cc70ab907e04ba0c3"
    sha256 cellar: :any, arm64_sequoia: "6a60f10375dea781b228d21898563abcf2c247fb2ac75f21eac372ece1474230"
    sha256 cellar: :any, arm64_sonoma:  "09b0f8531c31f92d1feb8add85b1b53d941ea38633338da13b06918c1b5a651d"
    sha256 cellar: :any, sonoma:        "c4fc53287a57a5a23e52c28a26b34d3818cc26f3ea072b6c343834c811d50e64"
    sha256 cellar: :any, arm64_linux:   "216e2f5564764584390b62942da76dec4963ebba7a95ccbd8472b0345eb8312b"
    sha256 cellar: :any, x86_64_linux:  "9c27f6c21daef3545a662a2da1ea3572b126037eed8fd623dc3021ebb3001fff"
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

  on_macos do
    depends_on "z3"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Backport support for LLVM 22
  patch do
    url "https://github.com/symengine/symengine/commit/a498ff2eadac2032d7a3982fc6dc3f69c4cca319.patch?full_index=1"
    sha256 "308abb8a03d8d132937f0340741030f6e8148030eef7fcfea12ab3e80b03d569"
    type :backport
    resolves "https://github.com/symengine/symengine/pull/2130"
  end
  patch do
    url "https://github.com/symengine/symengine/commit/de7305e5e2fee97d80c25164a8f8c9f7ecfc9953.patch?full_index=1"
    sha256 "09a5acf3043de18d5f09b2e28a6dc4edc127fe7e4b66e2656e3a0db4c26a5e6d"
    type :backport
    resolves "https://github.com/symengine/symengine/pull/2103"
    resolves "https://github.com/symengine/symengine/issues/2076"
  end
  patch do
    url "https://github.com/symengine/symengine/commit/ea9868e64ced2cd2abb9cdc3ae97d965b892b974.patch?full_index=1"
    sha256 "2a94699984ead1db45c024458783d13d70aa3b250bb72b1141502fb2287344ec"
    type :backport
    resolves "https://github.com/symengine/symengine/pull/2137"
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
      "-L#{formula_opt_lib("gmp")}", "-lgmp",
      "-L#{formula_opt_lib("mpfr")}", "-lmpfr",
      "-L#{formula_opt_lib("flint")}", "-lflint"
    ]
    system ENV.cxx, "test.cpp", "-std=c++11", "-L#{lib}", "-lsymengine", *lib_flags, "-o", "test"

    system "./test"
  end
end
