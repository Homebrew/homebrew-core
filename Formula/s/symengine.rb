class Symengine < Formula
  desc "Fast symbolic manipulation library written in C++"
  homepage "https://sympy.org"
  url "https://github.com/symengine/symengine/releases/download/v0.11.2/symengine-0.11.2.tar.gz"
  sha256 "f6972acd6a65354f6414e69460d2e175729470632bdac05919bc2f7f32e48cbd"
  license "MIT"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0ec354593497defa98b87c5c01f019e496c5434ca7be1cf0ccfad7aa3d353908"
    sha256 cellar: :any,                 arm64_ventura:  "df36bbe8ff66b72650d28b7cd821f7859c666ccbcd7d8d5148012ed73bb44414"
    sha256 cellar: :any,                 arm64_monterey: "30e10dc0a06e53f43fe3b02e7c988b997f66f7311f7c2ab8bdbc8d6df9fffeeb"
    sha256 cellar: :any,                 sonoma:         "d1142560a962fbd72bd6f3f78b34ef6cd6ba84b1abc9cf5abfa1bb7495051a2c"
    sha256 cellar: :any,                 ventura:        "08366ea97ec72c41f3ee3dc1cc8cbdf13453c4435a1dca76d0d68266c00c108d"
    sha256 cellar: :any,                 monterey:       "c551b89cec835f3f779e423e9e24771b062517b3f12a398f0f7671576874761f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1fd34da0b75f0bc3b416590152e333a3dcc041adc31c0cc0dac6eeaf2519db6"
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
