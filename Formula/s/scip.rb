class Scip < Formula
  desc "Solver for mixed integer programming and mixed integer nonlinear programming"
  homepage "https://scipopt.org"
  url "https://scipopt.org/download/release/scip-8.0.4.tgz"
  sha256 "4cdd13b812ecd6470c4baab60671b8eeddb405da9b7f0d5449c8b39fe8873081"
  license "Apache-2.0"

  livecheck do
    url "https://scipopt.org/scipdata.js"
    regex(/["']name["']:\s*?["']scip[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "49e507d74c748efd6069db58e0620eb1d54ae97d4e3dde1bdc0e296ff524f3a1"
    sha256 cellar: :any,                 arm64_ventura:  "3c209afa96be0e7b9ac5b0d4b115b16770e01e55a55bdd2305f9831a380215b7"
    sha256 cellar: :any,                 arm64_monterey: "cc885d3bcc74accb49984c5c1bdf1d0144ccd7676ee06cb153e378cfff097a5c"
    sha256 cellar: :any,                 arm64_big_sur:  "12d0cfcab902363893467134ffa7abe7c8168b0b0739cbf047a15d7898e224aa"
    sha256 cellar: :any,                 sonoma:         "8013c3e54c1d764a86e5b6aee0415c5a813d1e487cbbe64d15eb3f097e10188a"
    sha256 cellar: :any,                 ventura:        "7405d4bdec7fb54b5874c3c9505001796d60db122a72b191765bcfef55603d2a"
    sha256 cellar: :any,                 monterey:       "ff92caa47afaef81e505b13e5a5deb5520cecad8796a32fb97414b52d88940d1"
    sha256 cellar: :any,                 big_sur:        "845f3088c6c5779cdfffd362d5df2e699ba9f94b9d2b0447e025223c4c1ef39d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa5ffaf40b51a42d0d2343ff62996d6e17cc4ae47d513f353c8b8767f755a523"
  end

  depends_on "cmake" => :build
  depends_on "cppad"
  depends_on "gmp"
  depends_on "ipopt"
  depends_on "papilo"
  depends_on "readline"
  depends_on "soplex"
  uses_from_macos "zlib"

  def install
    cmake_args = %w[
      -DZIMPL=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *cmake_args, *std_cmake_args
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
