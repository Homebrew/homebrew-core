class Stp < Formula
  desc "Simple Theorem Prover, an efficient SMT solver for bitvectors"
  homepage "https://stp.github.io/"
  license "MIT"
  revision 4
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
    sha256 cellar: :any,                 arm64_sequoia: "14273492604bc38924086ea460c7aae0ec9d9443124f253d41ab69649ae348e8"
    sha256 cellar: :any,                 arm64_sonoma:  "3a9ce2263d91eed3e8f6205e69b327f613dd767065ebed03c329ac26de7fc9be"
    sha256 cellar: :any,                 arm64_ventura: "1627b2244a8c9510b46b0fdcfcaffdb5f55c21a528046a1988df5c2e4a10a33c"
    sha256 cellar: :any,                 sonoma:        "5160e4ed8537ddd8646866b7f0ddf4722f0be010b898e1708d6f22c974c9a866"
    sha256 cellar: :any,                 ventura:       "a3c9c4d00398271ec389ae631372e280d806dbdd6146e28d73417f71e7cd2bfe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3c927ba2276333d15e41be785894b0a65d1513f8e1932839564efc164fc6292"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9347d3517513e8d028b7fc993db150bc9d4751e1e450e97035339c007c4e0bd8"
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
