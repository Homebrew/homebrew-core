class Scip < Formula
  desc "Solver for mixed integer programming and mixed integer nonlinear programming"
  homepage "https://scipopt.org"
  url "https://scipopt.org/download/release/scip-9.2.0.tgz"
  sha256 "f2a1d568ba0801742df062df17b5a1ced9aec8647057050899e9017807280ff3"
  license "Apache-2.0"
  revision 1

  livecheck do
    url "https://scipopt.org/scipdata.js"
    regex(/["']name["']:\s*?["']scip[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b128fc2aeee92841095026ec503ff6f6419a7645750e487fc50068bfea2136ed"
    sha256 cellar: :any,                 arm64_sonoma:  "6946432bc33d1fb4cfdff48a76b8ba7c12ad3ed2b8c9e7cbb40824e20c985797"
    sha256 cellar: :any,                 arm64_ventura: "38229ab3998ef741a3d39436899dd3aa7c3293db0940364b4401f6d0e83663a3"
    sha256 cellar: :any,                 sonoma:        "a275e4ce98a8101c3ed082bca23ce6933f1e0ac211acd8e77843a026cbd873ae"
    sha256 cellar: :any,                 ventura:       "fc242b06983f141adf96a2b0f70c13fbcf719cdb8e462fd57f2c34e137be3c33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cad8f33f370b808688512b5e2db33811c937f6d480ffe1474efd190527fd8545"
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
