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
    rebuild 1
    manifest_sha256 "881473a855a1f61e68f8ed87b7e875c59c07972a60f70e0b2beae2db36914ed7"
    sha256 cellar: :any, arm64_golden_gate: "41281347fbfeb8f59414020e6f13f462329814541a4c722ac272d1afc794fedb"
    sha256 cellar: :any, arm64_tahoe:       "9ed629ee0192796326d57997ab3303864237546c5b786046e5e9148ed4a7373f"
    sha256 cellar: :any, arm64_sequoia:     "9229f0e0d9b34120eba3cbcb35280dd1d9417a295d64e29790148f952473f584"
    sha256 cellar: :any, arm64_linux:       "7f6f3e0d7e1f7a07411f2e597bb5e6155db424bf342e75de4569707a69f2b27c"
    sha256 cellar: :any, x86_64_linux:      "beccd9007cedfa158ced9155d8531c198f516ce60bc2543efecd3d34fab4ec94"
  end

  # stp refuses to build with system bison and flex
  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "cryptominisat"
  depends_on "minisat"
  depends_on "python@3.15"

  uses_from_macos "perl" => :build

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

  deny_network_access!

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
    args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac? # strip gmp linkage

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
