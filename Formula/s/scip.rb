class Scip < Formula
  desc "Solver for mixed integer programming and mixed integer nonlinear programming"
  homepage "https://scipopt.org"
  url "https://scipopt.org/download/release/scip-9.2.1.tgz"
  sha256 "d22982b1f31e44b111a673acd8250f093c7291303427392a0a8a253738a08258"
  license "Apache-2.0"

  livecheck do
    url "https://scipopt.org/scipdata.js"
    regex(/["']name["']:\s*?["']scip[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "de367f7dd372b27479eeacf5995692d6b391c70774038ba35e832287c6deb24a"
    sha256 cellar: :any,                 arm64_sonoma:  "736b6f699fdd915cdfce967c820671055340defa61f282fb294b349ace54ecf1"
    sha256 cellar: :any,                 arm64_ventura: "19449b5d25991180cc22a1e992d4e38493f89688e9836e6e31371d431e52f528"
    sha256 cellar: :any,                 sonoma:        "9fa220c37a33b5ab726d8333ba06c01510a1695386ffe24903970aba1b38d83d"
    sha256 cellar: :any,                 ventura:       "f624295be5c42e68fef393687527a6c93b8eddc2e7f492f56a3572ede91d5985"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fad05841ea03fcc75dc58a56c6411aab92165bf5e2e2c80b702fa7cb4093695d"
  end

  depends_on "cmake" => :build
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
