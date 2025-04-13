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
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "e3c0ea0b8289f05135760f81ecb6d3fd69893d8abb74ac7cf6bbb18d27b62564"
    sha256 cellar: :any,                 arm64_sonoma:  "c5a598b166a95048a125c05ccd17468c3c8f9630dccbfa9fc139226712ffa821"
    sha256 cellar: :any,                 arm64_ventura: "9936b569b1d85714133f4121c6159b9e180547e69420c8b7355a85a53cea3ed1"
    sha256 cellar: :any,                 sonoma:        "4351aaf662ebb4a694004316c51906e71e78e74579067a99d26f618892b64eca"
    sha256 cellar: :any,                 ventura:       "abeb86f540b13682ce7d7b0408f6aa943a61c8251c70594176201d953f48ecf0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a335d847bfafc248ce93d7984d1e0749c6942cc5eb5a2b66880bbefb1a359861"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e609d373696b0136ff2b00a0e60d9650e6f25e09ded107f35f5126701432dcd4"
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
