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
    sha256 cellar: :any,                 arm64_sequoia: "072edd52f6ce89e7fc81d084916be719688a866c1dd31a2f9ede2a64cb084ae4"
    sha256 cellar: :any,                 arm64_sonoma:  "a1399b0eff655005f402a11adcc096347374729aadd5ad9d7ce295a0fcaae960"
    sha256 cellar: :any,                 arm64_ventura: "6621bb96a6bf7f511dcbe740811708df215f64cc88f20ed730136c462186510f"
    sha256 cellar: :any,                 sonoma:        "9ee388681826cbb9dd84fcf0c4a74c2724955d80ce6f2b6cf59d05a3e8d55dd2"
    sha256 cellar: :any,                 ventura:       "5e33bec282deb0b3386d8795620dffd1da18ea626867084029f28d30e5e4d59c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1515635c7bb25f232df54d00ebe6d247775f6d23a470adf000cc71d01cfd3d69"
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
