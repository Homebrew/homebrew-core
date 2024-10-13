class Scip < Formula
  desc "Solver for mixed integer programming and mixed integer nonlinear programming"
  homepage "https://scipopt.org"
  url "https://scipopt.org/download/release/scip-9.1.1.tgz"
  sha256 "fd68a7ecc3c9086a68ef7ed0421381e811130f4c7dcb2c13ae69744577abd5cf"
  license "Apache-2.0"

  livecheck do
    url "https://scipopt.org/scipdata.js"
    regex(/["']name["']:\s*?["']scip[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c423a30bee48e5284391a79873d16b96ca882db083453fb6447c580fc43b56d5"
    sha256 cellar: :any,                 arm64_sonoma:  "8266df90b7d371ff4c19e22e86889bc1077557c2614321a519df874da2e8d3e2"
    sha256 cellar: :any,                 arm64_ventura: "d9110e241635f0f7931bcc420a2609a986f2dc75b047bed89d38410de169f781"
    sha256 cellar: :any,                 sonoma:        "d5c77cc3b140064843a11d9b46a8eafdc632f442faac6ba9949ec4d3531d2906"
    sha256 cellar: :any,                 ventura:       "041816294d0ef034027386f9e7f947c60fb3d5714b7499350af605750ef8c71e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe8b303f263ba6898325423fdd354a00d4d565652f2b51b4a84eea7f3ecee0be"
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
