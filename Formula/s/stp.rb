class Stp < Formula
  desc "Simple Theorem Prover, an efficient SMT solver for bitvectors"
  homepage "https://stp.github.io/"
  license "MIT"
  revision 5
  head "https://github.com/stp/stp.git", branch: "master"

  stable do
    url "https://github.com/stp/stp/archive/refs/tags/2.3.4.tar.gz"
    sha256 "dc197e337c058dc048451b712169a610f7040b31d0078b6602b831fbdcbec990"

    # Replace distutils for python 3.12+
    patch do
      url "https://github.com/stp/stp/commit/fb185479e760b6ff163512cb6c30ac9561aadc0e.patch?full_index=1"
      sha256 "7e50f26901e31de4f84ceddc1a1d389ab86066a8dcbc5d88e9ec1f0809fa0909"
    end
  end

  livecheck do
    url :stable
    regex(/^(?:stp[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e558a1e460a0e05dd9474e6be76a662023c6ebd0b15f6e960173b9f2334299ae"
    sha256 cellar: :any,                 arm64_sequoia: "339b5ca522f28f4c890811a0475f830c998e28c201de924ffe9d527d71062fea"
    sha256 cellar: :any,                 arm64_sonoma:  "72510b0dfa5b7def041a9bfe517f1ce594decfd5d1ef64433ac1a807fb927eac"
    sha256 cellar: :any,                 arm64_ventura: "e5cf95744fbfa173cd3975e2dd062ef4557119d33ce659375951f48a18ce9740"
    sha256 cellar: :any,                 sonoma:        "cd220bc18b982cafaa7947bce2e13d1dbfb45f65d376931c6f9eafb15536e5e5"
    sha256 cellar: :any,                 ventura:       "5e5dd55e9f0eddd08d9b069d7f125148994b1d8f23e0d0a2715d4abf4bef5d70"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fbf85992672d5a40bf34baefc415cbe5c1242124390a3b8d999b74a109bc8316"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0de6756be5199056e87ba8cbd8bc2daaf80440e633e7e72ac44bde9a9ee654bf"
  end

  # stp refuses to build with system bison and flex
  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "boost"
  depends_on "cryptominisat"
  depends_on "gmp"
  depends_on "minisat"
  depends_on "python@3.13"

  uses_from_macos "perl"

  # Use relative import for library_path
  patch do
    url "https://github.com/stp/stp/commit/f81d16c4f15863dd742d220d31db646b5d1c824d.patch?full_index=1"
    sha256 "c0c38f39371cfc9959df522957f45677f423a6b2d861f4ad87097c9201e00ff4"
  end

  def install
    python = "python3.13"
    site_packages = prefix/Language::Python.site_packages(python)
    site_packages.mkpath
    inreplace "lib/Util/GitSHA1.cpp.in", "@CMAKE_CXX_COMPILER@", ENV.cxx

    system "cmake", "-S", ".", "-B", "build",
                    "-DPYTHON_EXECUTABLE=#{which(python)}",
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

    assert_equal "True\n", shell_output("python3.13 test.py")
  end
end
