class Stp < Formula
  desc "Simple Theorem Prover, an efficient SMT solver for bitvectors"
  homepage "https://stp.github.io/"
  url "https://github.com/stp/stp/archive/refs/tags/2.3.3.tar.gz"
  sha256 "ea6115c0fc11312c797a4b7c4db8734afcfce4908d078f386616189e01b4fffa"
  license "MIT"
  revision 4
  head "https://github.com/stp/stp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:stp[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b9188be36cf6e66a2deb2323a203992512aedde79b0678902ec2b2b3ee6aaf36"
    sha256 cellar: :any,                 arm64_big_sur:  "4e97d6014677de6823fd686b367cf48a25ecb596f4923c7b03c840301dd8910f"
    sha256 cellar: :any,                 monterey:       "a631db1136e1f15dbda721c94613a4fd8bf1b379936b786c8c2c0cfe05ab3904"
    sha256 cellar: :any,                 big_sur:        "94e8b59b141f1d5ecf46f2f83613dcc5ad9387757bba424f9e952ee3d057757a"
    sha256 cellar: :any,                 catalina:       "4307faad5886b37273c1ecb89b4986953fe5d9bb8bd17474a64f9c3c31fb2cb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c4f1680d41f3d9d99beb3e24b79e9fc88db34da86764973e0e31180e96f05ff"
  end

  # stp refuses to build with system bison and flex
  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "boost"
  depends_on "cryptominisat"
  depends_on "minisat"
  depends_on "python@3.10"

  uses_from_macos "perl"

  def install
    python = "python3.10"
    site_packages = prefix/Language::Python.site_packages(python)
    site_packages.mkpath
    inreplace "lib/Util/GitSHA1.cpp.in", "@CMAKE_CXX_COMPILER@", ENV.cxx

    system "cmake", "-S", ".", "-B", "build",
                    "-DPYTHON_EXECUTABLE=#{Formula["python@3.10"].opt_bin}/#{python}",
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
