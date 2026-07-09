class Scip < Formula
  desc "Solver for mixed integer programming and mixed integer nonlinear programming"
  homepage "https://scipopt.org"
  url "https://scipopt.org/download/release/scip-10.0.3.tgz"
  sha256 "7fe90d216e1481b430eaed2bfc25c0349ffd73bfad6201bd96fa082dc54c1438"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/scipopt/scip"
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7a5d94c82d1e704abb4b64a0a3ae21bbea51307268bb191111d6705952a25107"
    sha256 cellar: :any, arm64_sequoia: "df296a77a559c5263983273bc68a3b30c001ab540c27798aacd0258bbbcf5abd"
    sha256 cellar: :any, arm64_sonoma:  "dc10945a5455bb3f2b7c9215dea89e2049aa458f3d48e23cc2fd4c6a1239cd64"
    sha256 cellar: :any, sonoma:        "2b68f3acd9a4c0197380b7a10876550b142f65936e8d4dddae1df55ce9c01fb1"
    sha256 cellar: :any, arm64_linux:   "7ccedb8dfa5ee651209e01c90326b4d84b1284a6970369a5103481e534d4cee3"
    sha256 cellar: :any, x86_64_linux:  "de5eaca960c321ad20b9e798514d9a3e3f662f43a92d552df5474ac6fb815edb"
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
