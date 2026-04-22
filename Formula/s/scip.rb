class Scip < Formula
  desc "Solver for mixed integer programming and mixed integer nonlinear programming"
  homepage "https://scipopt.org"
  url "https://scipopt.org/download/release/scip-10.0.2.tgz"
  sha256 "7544647007c9a63a770a71f5884a50ac81da37372bb6958d08588870bd58a50b"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/scipopt/scip"
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7c19c0c741487ae4510c4b6c9a1153a281a88f34fac38a003f7dd3c44c4b9079"
    sha256 cellar: :any,                 arm64_sequoia: "9b4274caff954b9a3c1cf1e9c7d40fc463bd85e2c2bb17a4d5ce655bd4efc4b4"
    sha256 cellar: :any,                 arm64_sonoma:  "74592695f57e9711b936f200c414bd56512ce0e58b5e103ea74a23d7084f0625"
    sha256 cellar: :any,                 sonoma:        "45073bd25f64ab72d9eba4dc9f2df699da72f3b7f309ca3fa22066af2a8a4a98"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9996d235dfe0374db8fbda66a93bef51d4c59ebcc63d44579764d8268068a2c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36cc79aa4cea363dfcc9356b9cefbba3d260c6cb27a69b83fb9f06b997c65262"
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
