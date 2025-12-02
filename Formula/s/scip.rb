class Scip < Formula
  desc "Solver for mixed integer programming and mixed integer nonlinear programming"
  homepage "https://scipopt.org"
  url "https://scipopt.org/download/release/scip-9.2.4.tgz"
  sha256 "d88217393a6f86c18f2957c6d36d90d28287a01473fb7378417ab49ad72a50ea"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/scipopt/scip"
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8e345527c5788204b410c15d3f9ad6ef3a30d626641c49c80429b96f93d8a28a"
    sha256 cellar: :any,                 arm64_sequoia: "8cfd22fa1f1a525de6a8fe28acf3b5c8ed7e3aaf0fff4bed1f323a56b29c6e00"
    sha256 cellar: :any,                 arm64_sonoma:  "a6d778cea731f914cb00cd4a8a8cc9465c4dfc28793c51025e078d087e27c011"
    sha256 cellar: :any,                 sonoma:        "fc8a392321d3640bd79af687a026e83ec83090ae1a78453474f1f1432a481803"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "87ead7c33e3744da5cc7d6a79955e7fcfc013338a8f49024eee7f82647ee46ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "beee5ba170ef0b8e55436ca899e694759c286d005c94277203a36b7cf6d74a45"
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
