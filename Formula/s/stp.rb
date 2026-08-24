class Stp < Formula
  desc "Simple Theorem Prover, an efficient SMT solver for bitvectors"
  homepage "https://stp.github.io/"
  url "https://github.com/stp/stp/archive/refs/tags/2.4.1.tar.gz"
  sha256 "6f8bca3612e3d61868450dbf7771897b2a909f446e8de460bdf31f13a6cd0318"
  license "MIT"
  revision 1
  compatibility_version 1
  head "https://github.com/stp/stp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:stp[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8c80280e9010ee4f6d9b8d3209a22db3165174ad547995c864b70deb05c01519"
    sha256 cellar: :any, arm64_sequoia: "566f097aa3fd82f63b405394b3dfd22d0fc6d97f083771f51c8fe3949c86043f"
    sha256 cellar: :any, arm64_sonoma:  "6ffeab720b5ba93ee2d2b5aaec0fc0d11be336ceb33cf6c226c87b5dc088608e"
    sha256 cellar: :any, sonoma:        "3b8b9955b7c6785bcc1223282d97fea39279c6f1bc21d6aff9c9d8647f3b20fd"
    sha256 cellar: :any, arm64_linux:   "6fed04895b8b20d2e8f7584b33ac235c31d472a5cbbde9f5c525068c33214530"
    sha256 cellar: :any, x86_64_linux:  "86e662b2511abad1e3044eec93c903554f308e853dad949c4ec45c02939b73a9"
  end

  # stp refuses to build with system bison and flex
  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "boost"
  depends_on "cryptominisat"
  depends_on "gmp"
  depends_on "minisat"
  depends_on "python@3.14"

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

    python = "python3.14"
    site_packages = prefix/Language::Python.site_packages(python)
    site_packages.mkpath
    inreplace "lib/Util/GitSHA1.cpp.in", "@CMAKE_CXX_COMPILER@", ENV.cxx

    args = %W[
      -DPYTHON_EXECUTABLE=#{which(python)}
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

    assert_equal "True\n", shell_output("python3.14 test.py")
  end
end
