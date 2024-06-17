class Stp < Formula
  desc "Simple Theorem Prover, an efficient SMT solver for bitvectors"
  homepage "https://stp.github.io/"
  url "https://github.com/stp/stp/archive/refs/tags/2.3.4.tar.gz"
  sha256 "dc197e337c058dc048451b712169a610f7040b31d0078b6602b831fbdcbec990"
  license "MIT"
  head "https://github.com/stp/stp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:stp[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8d2d25a991994393947c9a10811348f58f9d7be146566ffeddd25eb96798b3c7"
    sha256 cellar: :any,                 arm64_ventura:  "dcae4c325d93deac3fbf35f47644b257c6d8ccbe8cf4fd4cd5ca3e5be5b81b9a"
    sha256 cellar: :any,                 arm64_monterey: "a0992a32a881c907b6ea4640339763d0bffd046f2a84da39ccf466d149580c3e"
    sha256 cellar: :any,                 sonoma:         "853f39ffae6259944569b262cf249aaa4c4c92f3e2bae830d291ea683206d848"
    sha256 cellar: :any,                 ventura:        "f67fbc50dc10ed864f5152aa657544f6e0a6f26464d0bf8d86040a54c0c0c808"
    sha256 cellar: :any,                 monterey:       "f881bf0041b5151c962b9df594f145785230732f2d1988ff057725323d89b2b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8280802ee8e53554ae5ce0a383158f0e84bcf7cc623df11c5dbe45dee623e5a0"
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
