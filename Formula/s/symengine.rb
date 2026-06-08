class Symengine < Formula
  desc "Fast symbolic manipulation library written in C++"
  homepage "https://www.sympy.org/en/index.html"
  url "https://github.com/symengine/symengine/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "11c5f64e9eec998152437f288b8429ec001168277d55f3f5f1df78e3cf129707"
  license "MIT"
  revision 7

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f2288896b8b0640c79042d9ae0f3affdb6a94c6526a7e264eac670ba3e957979"
    sha256 cellar: :any,                 arm64_sequoia: "afc0896485540e6e212776a3a87c092f0a997f6a72d178025f9c2099ec39e9ae"
    sha256 cellar: :any,                 arm64_sonoma:  "3010cbb359c9ad63fa5eac98a45141b798f04313a8ba37cf913a77da534af887"
    sha256 cellar: :any,                 sonoma:        "36878b0e8342a4856f043a44212dc7731f10808b35892d639030fff4a0be0bb3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e623eca2e1cce8e068eada5290a48c06ecf1c48aaaca761a591964326d765657"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18af9b2b880650c127541e3c24079d46f566f54669a4456fcc98e8e8a221683f"
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
  end
  patch do
    url "https://github.com/symengine/symengine/commit/de7305e5e2fee97d80c25164a8f8c9f7ecfc9953.patch?full_index=1"
    sha256 "09a5acf3043de18d5f09b2e28a6dc4edc127fe7e4b66e2656e3a0db4c26a5e6d"
  end
  patch do
    url "https://github.com/symengine/symengine/commit/ea9868e64ced2cd2abb9cdc3ae97d965b892b974.patch?full_index=1"
    sha256 "2a94699984ead1db45c024458783d13d70aa3b250bb72b1141502fb2287344ec"
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
      "-L#{Formula["gmp"].opt_lib}", "-lgmp",
      "-L#{Formula["mpfr"].opt_lib}", "-lmpfr",
      "-L#{Formula["flint"].opt_lib}", "-lflint"
    ]
    system ENV.cxx, "test.cpp", "-std=c++11", "-L#{lib}", "-lsymengine", *lib_flags, "-o", "test"

    system "./test"
  end
end
