class Stp < Formula
  desc "Simple Theorem Prover, an efficient SMT solver for bitvectors"
  homepage "https://stp.github.io/"
  url "https://github.com/stp/stp/archive/refs/tags/2.4.1.tar.gz"
  sha256 "6f8bca3612e3d61868450dbf7771897b2a909f446e8de460bdf31f13a6cd0318"
  license "MIT"
  revision 2
  compatibility_version 1
  head "https://github.com/stp/stp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:stp[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f20949480e0757bce49451dc2daebf36031ff8beeedb5ea4f04ce845800d386e"
    sha256 cellar: :any, arm64_tahoe:       "5727302d16e580e627c7dee12baf30b690332cd844f39ce118c8a86e437a75c4"
    sha256 cellar: :any, arm64_sequoia:     "a78706e0ee2ab1b18a4c7f0883ebddcd3adf2668fe1775dd139ad46a2f86eecb"
    sha256 cellar: :any, arm64_linux:       "1c991daf31f4d69de1f14d3d1915eb002063070a3ca4ffda915c573b2796c7bc"
    sha256 cellar: :any, x86_64_linux:      "73675034aaf5c0029c9006edef7fd691082c4505fa39c46e3138b5312977b6df"
  end

  # stp refuses to build with system bison and flex
  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "boost"
  depends_on "cryptominisat"
  depends_on "gmp"
  depends_on "minisat"
  depends_on "python@3.15"

  uses_from_macos "perl"

  # Must match the `lib/extlib-abc` submodule as stp builds only the ABC sources that revision needs
  resource "extlib-abc" do
    url "https://github.com/berkeley-abc/abc.git",
      revision: "95393064368b7c05da4d6f0264fc3419c175c7cb"
    version "95393064368b7c05da4d6f0264fc3419c175c7cb"

    livecheck do
      url "https://api.github.com/repos/stp/stp/contents/lib/extlib-abc?ref=#{LATEST_VERSION}"
      strategy :json do |json|
        json["sha"]
      end
    end
  end

  def install
    resource("extlib-abc").stage buildpath/"lib/extlib-abc"

    site_packages = prefix/Language::Python.site_packages(python3)
    site_packages.mkpath
    inreplace "lib/Util/GitSHA1.cpp.in", "@CMAKE_CXX_COMPILER@", ENV.cxx

    args = %W[
      -DPYTHON_EXECUTABLE=#{python3}
      -DPYTHON_LIB_INSTALL_DIR=#{site_packages}
      -DSTP_ALLOCATOR=system
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"prob.smt").write <<~LISP
      (set-logic QF_BV)
      (assert (= (bvsdiv (_ bv3 2) (_ bv2 2)) (_ bv0 2)))
      (check-sat)
      (exit)
    LISP
    assert_equal "sat", shell_output("#{bin}/stp --SMTLIB2 prob.smt").chomp

    (testpath/"test.c").write <<~C
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
    C

    expected_output = <<~EOS
      COUNTEREXAMPLE BEGIN:\s
      ASSERT( c = 0x0000000B );
      COUNTEREXAMPLE END:\s
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lstp", "-o", "test"
    assert_equal expected_output.chomp, shell_output("./test").chomp

    (testpath/"test.py").write <<~PYTHON
      import stp
      s = stp.Solver()
      a = s.bitvec('a', 32)
      b = s.bitvec('b', 32)
      c = s.bitvec('c', 32)
      s.add(a == 5)
      s.add(b == 6)
      s.add(a + b == c)
      print(s.check())
    PYTHON

    assert_equal "True\n", shell_output("#{python3} test.py")
  end
end
