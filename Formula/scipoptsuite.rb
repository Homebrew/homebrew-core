class Scipoptsuite < Formula
  desc "Mixed Integer Programming (MIP) solver and Branch-and-Cut-and-Price Framework"
  homepage "https://www.scipopt.org/"
  url "https://www.scipopt.org/download/release/scipoptsuite-8.0.3.tgz"
  sha256 "5ad50eb42254c825d96f5747d8f3568dcbff0284dfbd1a727910c5a7c2899091"
  license all_of: ["Apache-2.0", "LGPL-3.0-or-later"]

  depends_on "bison@2.7"
  depends_on "boost"
  depends_on "cmake"
  depends_on "cppad"
  depends_on "gmp"
  depends_on "gnuplot"
  depends_on "ipopt"
  depends_on "tbb"

  uses_from_macos "flex"
  uses_from_macos "zlib"

  def install
    cmake_args = std_cmake_args + %W[
      -DPARASCIP=ON
      -DPAPILO=ON
      -DSOPLEX=ON
      -DGCG=ON
      -DZIMPL=ON
      -DBOOST=ON
      -DGMP=ON
      -DQUADMATH=ON
      -DIPOPT=ON
      -DIPOPT_DIR="#{prefix}"
      -DZLIB=ON
      -DREADLINE=OFF
      -DSYM=bliss
      -DEXPRINT=cppad
      -DCLIQUER=OFF
    ]

    system "cmake", "-B", "scipoptsuite-build", "-S", ".", *cmake_args
    system "cmake", "--build", "scipoptsuite-build"
    system "cmake", "--install", "scipoptsuite-build"

    prefix.install "scip/check/instances/MIP/enigma.mps"
  end

  test do
    output = shell_output("#{bin}/scip -c \"r #{prefix}/enigma.mps opt q\"")
    assert_match "optimal solution found", output
  end
end
