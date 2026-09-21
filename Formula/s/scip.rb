class Scip < Formula
  desc "Solver for mixed integer programming and mixed integer nonlinear programming"
  homepage "https://scipopt.org", browsed: "2026-09-18"
  url "https://scipopt.org/download/release/scip-10.1.0.tgz"
  sha256 "fe8cfd15a03970ef45156ed56c6a4382485bd095e0e99cf7d7db87cdf8d47304"
  license "Apache-2.0"
  compatibility_version 1

  livecheck do
    url "https://github.com/scipopt/scip"
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "71394d6ace28a14dc76b6b43dbe9a1f11ab83ca7b7f6e063475d60b13aa40c3a"
    sha256 cellar: :any, arm64_tahoe:       "2a856e103a7f6e88d048316e016c5e95247a2815f2b678f1bba73c556e3818d5"
    sha256 cellar: :any, arm64_sequoia:     "bfe7455c138840fab4c81089d7b6b2424e8330b1f2fa61eaea2f1212017897f2"
    sha256 cellar: :any, arm64_linux:       "c5fccc3a85ba12c92ced74ff4bb212556fe6c50be3aae9efabee6517c7ed894e"
    sha256 cellar: :any, x86_64_linux:      "ae5473952780d42b25b3cf9aa70a4647f009a9ad74736d786d97d6935703d26b"
  end

  depends_on "cmake" => :build
  depends_on "papilo" => :build # for static libraries
  depends_on "soplex" => :build # for static libraries
  depends_on "cppad" => :no_linkage
  depends_on "gcc" # for gfortran
  depends_on "gmp"
  depends_on "ipopt"
  depends_on "mpfr"
  depends_on "openblas"
  depends_on "readline"
  depends_on "tbb"

  on_macos do
    depends_on "boost"
  end

  on_linux do
    depends_on "boost" => :no_linkage
    depends_on "zlib-ng-compat"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DZIMPL=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "check/instances/MIP/enigma.mps"
    pkgshare.install "check/instances/MINLP/gastrans.nl"
    pkgshare.install "check/instances/MIPEX/flugpl_rational.mps"
  end

  test do
    expected = "problem is solved [optimal solution found]"
    assert_match expected, shell_output("#{bin}/scip -f #{pkgshare}/enigma.mps")
    assert_match expected, shell_output("#{bin}/scip -f #{pkgshare}/gastrans.nl")

    command = "set exact enable TRUE read #{pkgshare}/flugpl_rational.mps optimize quit"
    assert_match expected, shell_output("#{bin}/scip -c \"#{command}\"")
  end
end
