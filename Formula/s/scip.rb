class Scip < Formula
  desc "Solver for mixed integer programming and mixed integer nonlinear programming"
  homepage "https://scipopt.org"
  url "https://scipopt.org/download/release/scip-10.0.1.tgz"
  sha256 "1a8a14dc28064748eabcde82c09978d07fc1005f8bc7a8be1a8bc092b7dbfe68"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/scipopt/scip"
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "d6763c8b4026e7a7b76d8202ab3170da7f192cd9bc35d1a1ae5e143c38ad8d7e"
    sha256 cellar: :any,                 arm64_sequoia: "57f950b9758a74626defd154c6741919647b0784ba1503aa0157ae86ea5e5936"
    sha256 cellar: :any,                 arm64_sonoma:  "bb1bdff5f0720197835b422faa05fcc24aa3922a607fd47aab02a55e0d79144e"
    sha256 cellar: :any,                 sonoma:        "c06ded6eb98947e0c9bc59e0ffd2b7842ae77c6769b922768e877118b6425f8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59c7867bfe4349b2f42887e8a4e472ac934b5e987314efbf72793b66b3b616d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4d463b473ce46312fa9cbc28dca49bbdb08b4bace0deb40e4bf6fd00e03bce6"
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
