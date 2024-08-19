class Stp < Formula
  desc "Simple Theorem Prover, an efficient SMT solver for bitvectors"
  homepage "https://stp.github.io/"
  url "https://github.com/stp/stp/archive/refs/tags/2.3.4.tar.gz"
  sha256 "dc197e337c058dc048451b712169a610f7040b31d0078b6602b831fbdcbec990"
  license "MIT"
  revision 1
  head "https://github.com/stp/stp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:stp[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "95e15af6a14beb3660a270b7686a6d80e5ce0bad483137dd8f6e55b9e084776d"
    sha256 cellar: :any,                 arm64_ventura:  "46a50b47c60a22bdc702279dd8e87670192255e1512ce9f925a067c049daa0c7"
    sha256 cellar: :any,                 arm64_monterey: "225bd9e76bdcf19d25386a9987d15aa2a4750581ea44d05cac8e29beb729560c"
    sha256 cellar: :any,                 sonoma:         "a4db0af253a912c9164c3b1142a98740f2947c1997638d6b85a299afcfd87128"
    sha256 cellar: :any,                 ventura:        "2fbab5de52f21a9422a222328fa052708e5fd63905519ce91370be39e138b46b"
    sha256 cellar: :any,                 monterey:       "7622e6bedcc64986cd9a712f524c30971aa277704bf8871c9ea6c5fe90da257e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "277f72788a93cd7f9eb2585b48b864bc15d40ae055c4569ac7faa6f5e435b061"
  end

  # stp refuses to build with system bison and flex
  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "python-setuptools" => :build
  depends_on "boost"
  depends_on "cryptominisat"
  depends_on "gmp"
  depends_on "minisat"
  depends_on "python@3.12"

  uses_from_macos "perl"

  def install
    python = "python3.12"
    site_packages = prefix/Language::Python.site_packages(python)
    site_packages.mkpath
    inreplace "lib/Util/GitSHA1.cpp.in", "@CMAKE_CXX_COMPILER@", ENV.cxx

    system "cmake", "-S", ".", "-B", "build",
                    "-DPYTHON_EXECUTABLE=#{Formula["python@3.12"].opt_bin}/#{python}",
                    "-DPYTHON_LIB_INSTALL_DIR=#{site_packages}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"prob.smt").write <<~EOS
      (set-logic QF_BV)
      (assert (= (bvsdiv (_ bv3 2) (_ bv2 2)) (_ bv0 2)))
      (check-sat)
      (exit)
    EOS
    assert_equal "sat", shell_output("#{bin}/stp --SMTLIB2 prob.smt").chomp

    (testpath/"test.c").write <<~EOS
      #include "stp/c_interface.h"
      #include <assert.h>
      int main() {
        VC vc = vc_createValidityChecker();
        Expr c = vc_varExpr(vc, "c", vc_bvType(vc, 32));
        Expr a = vc_bvConstExprFromInt(vc, 32, 5);
        Expr b = vc_bvConstExprFromInt(vc, 32, 6);
        Expr xp1 = vc_bvPlusExpr(vc, 32, a, b);
        Expr eq = vc_eqExpr(vc, xp1, c);
        Expr eq2 = vc_notExpr(vc, eq);
        int ret = vc_query(vc, eq2);
        assert(ret == false);
        vc_printCounterExample(vc);
        vc_Destroy(vc);
        return 0;
      }
    EOS

    expected_output = <<~EOS
      COUNTEREXAMPLE BEGIN:\s
      ASSERT( c = 0x0000000B );
      COUNTEREXAMPLE END:\s
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lstp", "-o", "test"
    assert_equal expected_output.chomp, shell_output("./test").chomp
  end
end
