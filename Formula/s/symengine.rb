class Symengine < Formula
  desc "Fast symbolic manipulation library written in C++"
  homepage "https://www.sympy.org/en/index.html"
  url "https://github.com/symengine/symengine/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "11c5f64e9eec998152437f288b8429ec001168277d55f3f5f1df78e3cf129707"
  license "MIT"
  revision 9

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "111c32b0a2791370cf601a95eb1ea9d6e24e29d8acfa2399e668c0fadccf46e8"
    sha256 cellar: :any, arm64_tahoe:       "8b28f48a54a6d81388f45bc049629958a65e32bf2abf3d41249a6af959a373fa"
    sha256 cellar: :any, arm64_sequoia:     "b464c90653102771a7cc93f72987b14201e870e853e1d0966abfaff08f18bcd4"
    sha256 cellar: :any, arm64_sonoma:      "6c0a2a4b9e1c29b21c606273b087d3de2e5ad2c6c20e23ee2556f31b7a412a3d"
    sha256 cellar: :any, sonoma:            "231d9a0381a4527eec52a88d18a2abb7804b5252180e9196dd4acf7b3c26c48e"
    sha256 cellar: :any, arm64_linux:       "6ab8b93dbd2c4e254c7b0383b8549144cbce642feafe48c2f68a402d1c56418e"
    sha256 cellar: :any, x86_64_linux:      "dc882e671021a8c90911fa06fce8d8a1a6a4fea8a1a137bd05d435978daa2d63"
  end

  depends_on "cereal" => :build
  depends_on "cmake" => :build
  depends_on "flint"
  depends_on "gmp"
  depends_on "libmpc"
  depends_on "llvm"
  depends_on "mpfr"

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
