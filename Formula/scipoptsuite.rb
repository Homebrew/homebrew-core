class Scipoptsuite < Formula
  desc "Mixed Integer Programming (MIP) solver and Branch-and-Cut-and-Price Framework"
  homepage "https://scipopt.org/"
  url "https://www.scipopt.org/download/release/scipoptsuite-8.0.3.tgz"
  sha256 "5ad50eb42254c825d96f5747d8f3568dcbff0284dfbd1a727910c5a7c2899091"
  license all_of: ["Apache 2.0", "ZIB-Academic", "LGPL-3.0-or-later"]

  depends_on "cmake" => :build
  depends_on "tbb"
  depends_on "ipopt"
  depends_on "cppad"
  depends_on "boost"
  depends_on "gmp"
  depends_on "bison"
  depends_on "flex"
  depends_on "gnuplot"
  depends_on "zlib"

  def install
    cmake_args = std_cmake_args + %w[
      -DPARASCIP=ON
      -DPAPILO=ON
      -DSOPLEX=ON
      -DGCG=ON
      -DZIMPL=ON
      -DBOOST=ON
      -DGMP=ON
      -DQUADMATH=ON
      -DIPOPT=ON
      -DIPOPT_DIR="${PREFIX}"
      -DZLIB=ON
      -DREADLINE=OFF
      -DSYM=bliss
      -DEXPRINT=cppad
      -DCLIQUER=OFF
    ]

    system "cmake", "-B", "scipoptsuite-build", "-S", ".", *cmake_args
    system "cmake", "--build", "scipoptsuite-build"
    system "cmake", "--install", "scipoptsuite-build", "--prefix", "${PREFIX}"
  end

  test do
    system "cmake", "-B", "build", "-S", "scipoptsuite/scip/examples/Queens", "-DCMAKE_BUILD_TYPE=Release"
    system "cmake", "--build", "build", "--parallel", "${CPU_COUNT}"
    system "./build/queens", "5"

    system "scip", "--version"

    # Verifies that dependencies are properly linked
    output = shell_output("scip --version")
    assert_match /CppAD\s+[0-9]+/, output
    output = shell_output("scip --version")
    assert_match /ZLIB\s+[0-9]+\.[0-9]+\.[0-9]+/, output
    output = shell_output("scip --version")
    assert_match /GMP\s+[0-9]+\.[0-9]+\.[0-9]+/, output
    output = shell_output("scip --version")
    assert_match /bliss\s+[0-9]+\.[0-9]+/, output
    output = shell_output("scip --version")
    assert_match /Ipopt\s+[0-9]+\.[0-9]+\.[0-9]+/, output
  end
end
