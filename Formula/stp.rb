class Stp < Formula
  desc "Simple Theorem Prover, an efficient SMT solver for bitvectors"
  homepage "https://stp.github.io/"
  url "https://github.com/stp/stp/archive/refs/tags/2.3.3.tar.gz"
  sha256 "ea6115c0fc11312c797a4b7c4db8734afcfce4908d078f386616189e01b4fffa"
  license "MIT"
  revision 6
  head "https://github.com/stp/stp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:stp[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "11f98021c059c0b510d2a7d0245037832b3b3a7348a43b15f19a849d5a11e9d6"
    sha256 cellar: :any,                 arm64_monterey: "6daedfc806728ad067500b9cce8aae26b76c2026317b90f6aeb9cdadd3979f95"
    sha256 cellar: :any,                 arm64_big_sur:  "cd1329b5f9035e9add08a7cbd12b5ed644cd49dfbb9c5468377ef423cebedd93"
    sha256 cellar: :any,                 ventura:        "bd2c430c8ab7bc3bedff913245869da6c3b6715cdb6329ea077a497c67301f01"
    sha256 cellar: :any,                 monterey:       "f17957b6ca37ee88003ea4d66b98b409d0c2bb39116089858742fe5496082060"
    sha256 cellar: :any,                 big_sur:        "8f4b0d7f28d70fd02d5b7afef3d1efec1b0313e3477c96274c7e7aab35757cb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e43192bd96fd4143fe4dce2055eeec42be74c8775ede475bd0a87b5b1e79081"
  end

  # stp refuses to build with system bison and flex
  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "boost"
  depends_on "cryptominisat"
  depends_on "minisat"
  depends_on "python@3.11"

  uses_from_macos "perl"

  def install
    python = "python3.11"
    site_packages = prefix/Language::Python.site_packages(python)
    site_packages.mkpath
    inreplace "lib/Util/GitSHA1.cpp.in", "@CMAKE_CXX_COMPILER@", ENV.cxx

    system "cmake", "-S", ".", "-B", "build",
                    "-DPYTHON_EXECUTABLE=#{Formula["python@3.11"].opt_bin}/#{python}",
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
