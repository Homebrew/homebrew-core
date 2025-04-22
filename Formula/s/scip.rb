class Scip < Formula
  desc "Solver for mixed integer programming and mixed integer nonlinear programming"
  homepage "https://scipopt.org"
  url "https://scipopt.org/download/release/scip-9.2.2.tgz"
  sha256 "07c237f2f694c8f24ec9a1b22bcd7cef530b74446f46cfb13905b1a2c3759e5e"
  license "Apache-2.0"

  livecheck do
    url "https://scipopt.org/scipdata.js"
    regex(/["']name["']:\s*?["']scip[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4dde6d4b7e2f2087494f51e6100efb2b8520e62b3eaf53099c3bc9b80fc2caa8"
    sha256 cellar: :any,                 arm64_sonoma:  "7d0c7bf8d404aaacc91084650b9ddd668e386ca03ff1336aa151b149499763a6"
    sha256 cellar: :any,                 arm64_ventura: "0fdd982ee31e651a635eeadbb7901d1f199e8b39831f43b523fd8a4dd666eab3"
    sha256 cellar: :any,                 sonoma:        "29d1ded0c685a822db19a4330cf90dc7414aa28bca40cdab7301334c58a311e5"
    sha256 cellar: :any,                 ventura:       "7446a9c4cf648c4116c12c69f18722fab89508579623abdadc88f0568356be2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80ec7086e74c4b1c13c7a1e21c283e253579dd51fde2c4821a68d03abaae956c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a4f2f8dda7010132726058e4111dbcf41d4d1d4e8c328abf7b709068716da4a"
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
