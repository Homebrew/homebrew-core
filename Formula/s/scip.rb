class Scip < Formula
  desc "Solver for mixed integer programming and mixed integer nonlinear programming"
  homepage "https://scipopt.org"
  url "https://scipopt.org/download/release/scip-9.2.3.tgz"
  sha256 "6f5e81a643bba22d9b4e43cd97583529587c64eafe83b93bb864b07f9f16fab7"
  license "Apache-2.0"
  revision 1

  livecheck do
    url "https://scipopt.org/scipdata.js"
    regex(/["']name["']:\s*?["']scip[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f6e535f1d4849caa3a370c080d62c650781a727b42edb571a994e2167fd22984"
    sha256 cellar: :any,                 arm64_sonoma:  "c04ca5649c3eaf2e85871b43dde1365581af0ed741e2f9a43994fafefed2cc4d"
    sha256 cellar: :any,                 arm64_ventura: "558bacec51d5c471dc25e32aa2de30916214a375a84c870b1ccbffea4da9e4c1"
    sha256 cellar: :any,                 sonoma:        "6dac9de291e0f7e3c273360b576aaff7300f265a35f465e7fbcc77ae6b4286ed"
    sha256 cellar: :any,                 ventura:       "6df41e98901b04ff56ad50dba1d1744c4cfde6bdbe39e2f5aaa8ca8bb3d45405"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e610c3db3ba7a6ede4d264746e438b7d669be5305b5d9b5aaf3f7e639a8c048"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "782accbc4741331d07dd997269283dae94d281b3e3d47b22c7baf927b59511e5"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "cppad"
  depends_on "gmp"
  depends_on "ipopt"
  depends_on "openblas"
  depends_on "papilo"
  depends_on "readline"
  depends_on "soplex"
  depends_on "tbb"

  uses_from_macos "zlib"

  on_macos do
    depends_on "gcc"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DZIMPL=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "check/instances/MIP/enigma.mps"
    pkgshare.install "check/instances/MINLP/gastrans.nl"
  end

  test do
    assert_match "problem is solved [optimal solution found]", shell_output("#{bin}/scip -f #{pkgshare}/enigma.mps")
    assert_match "problem is solved [optimal solution found]", shell_output("#{bin}/scip -f #{pkgshare}/gastrans.nl")
  end
end
