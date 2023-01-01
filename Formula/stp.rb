class Stp < Formula
  desc "Simple Theorem Prover, an efficient SMT solver for bitvectors"
  homepage "https://stp.github.io/"
  url "https://github.com/stp/stp/archive/refs/tags/2.3.3.tar.gz"
  sha256 "ea6115c0fc11312c797a4b7c4db8734afcfce4908d078f386616189e01b4fffa"
  license "MIT"
  revision 5
  head "https://github.com/stp/stp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:stp[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "04b2bf31bf46e41d8cc75096e53cbf591400797d9d80319e924052b181774e7c"
    sha256 cellar: :any,                 arm64_monterey: "3a59742ce97c28d53372e5890aadecc132353bce698ed5292a93fc5bdcd4d4e1"
    sha256 cellar: :any,                 arm64_big_sur:  "dd48b665715c672b2b9d4966ac00609b20e1da4dd35ff2acdd617748597d506b"
    sha256 cellar: :any,                 ventura:        "50db753746537b8cbba6853456332c57375fc3e63b459f0bfd994a41fccfd437"
    sha256 cellar: :any,                 monterey:       "33dc2648b086d748e025dfe384946525afcbcaa477d25ceb4d646fcba99d4c73"
    sha256 cellar: :any,                 big_sur:        "687091372d5d0ca1afb5555e9e8741f4955996f42d5b21d010a9c81aeaa1c3d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e7daf57a9e46e15e13cd8b9182675785a345de0f5f15c86e60d957a3b439862"
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
