class Scip < Formula
  desc "Solver for mixed integer programming and mixed integer nonlinear programming"
  homepage "https://scipopt.org"
  url "https://scipopt.org/download/release/scip-10.0.0.tgz"
  sha256 "b91d2ed32c422a13c502c37cf296eb9550e55d6bd311e61bfa6dfb9811b03d87"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/scipopt/scip"
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d34ce00329bf1ee4b0eb0e173c8a32559d3e5ed807a58ce7c38d64b2a5a8b515"
    sha256 cellar: :any,                 arm64_sequoia: "53cc523a67b262b84cfcd148cc45e341b0e78af1a09726f05cd3806ca96a816a"
    sha256 cellar: :any,                 arm64_sonoma:  "14e01b3befd24f3a7c7a6f4fcc5ac8040207d6c6b558e88b55de1571d05c6420"
    sha256 cellar: :any,                 sonoma:        "169ba2332962c0dd133d2d818132af9dec46687cb34cb2b464350a2a7b847cbf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e261bc85758fd9965ef7173d4b7eb14d4cbf09228a1835df0ec34043bc92fc52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2159678993d921f14507fa26cc06e12d51e383df2079b8bbe5f03321c2aaac4c"
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

  uses_from_macos "zlib"

  on_macos do
    depends_on "boost"
  end

  on_linux do
    depends_on "boost" => :no_linkage
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
