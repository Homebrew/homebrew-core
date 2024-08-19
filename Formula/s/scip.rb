class Scip < Formula
  desc "Solver for mixed integer programming and mixed integer nonlinear programming"
  homepage "https://scipopt.org"
  url "https://scipopt.org/download/release/scip-9.1.0.tgz"
  sha256 "40459696c513c376bd1dbde10744837d0d4d4b9359df26243e749ba7991481f6"
  license "Apache-2.0"

  livecheck do
    url "https://scipopt.org/scipdata.js"
    regex(/["']name["']:\s*?["']scip[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "705a97ff1ca9f055004c006185e899c99d05a12d0e5c3609f86ca675fbb57e43"
    sha256 cellar: :any,                 arm64_ventura:  "896b0868587888345ace85d2ec03f9cd265d753ad320c07ed0bba89de8b756a7"
    sha256 cellar: :any,                 arm64_monterey: "1803a116966786bdda39fd83cd1c288f76419273eea70475ee8ccd8e0880eac6"
    sha256 cellar: :any,                 sonoma:         "ad3ac0efe663d0842daa73b1dae468057a26494d2893d57bbc21fb9d7160772b"
    sha256 cellar: :any,                 ventura:        "895f958e2dbad907ebd9155ced804c8a884bd6cecfcf10e39d366a2e78b02191"
    sha256 cellar: :any,                 monterey:       "dafe677b7d8aa59f5f11383fbb52ad4b6fa818c6e5e1e6f3903045fa0f99b37c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "611c37768da18821b98a4233005548ec9d4867b726a2713e8f36b94ccc90c007"
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
