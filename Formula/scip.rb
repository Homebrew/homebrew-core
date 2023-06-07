class Scip < Formula
  desc "Solver for mixed integer programming and mixed integer nonlinear programming"
  homepage "https://scipopt.org"
  url "https://scipopt.org/download/release/scip-8.0.3.tgz"
  sha256 "0dc6297a32e9ebe5fc9d0aa9f9168ec7ea3c2ce551596356c4076eab8a470850"
  license "Apache-2.0"

  livecheck do
    url "https://scipopt.org/scipdata.js"
    regex(/["']name["']:\s*?["']scip[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e2683ea1ea7ef4ee746ed37f18d569658259b068f8133870325fec0060f220af"
    sha256 cellar: :any,                 arm64_monterey: "d558dfdbaa7da6c11c8010aa6d14cab0b4d1cc4ccc0a389b43a793735a6af192"
    sha256 cellar: :any,                 arm64_big_sur:  "a672ad65af2f34e4d261115ceca920f195bd0f56d606963c2e03ee52dfb24574"
    sha256 cellar: :any,                 ventura:        "0c32b38a5d2eb36dc977132bc43cad9f89cb08fb460b20c130e52ade6158a269"
    sha256 cellar: :any,                 monterey:       "5b7579f0c5485ce9a25a7dea0c928a3ac8458c5e175d6dccbffc09f9767e315f"
    sha256 cellar: :any,                 big_sur:        "104b385e43bdf7a3c5d415b98cdcae456f82e3601ced38cc378fe7bd8af0f22a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd5e992bf62418a05ce7c0d921d9b5df50506e04da53bd4005145aa7d8da1062"
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
