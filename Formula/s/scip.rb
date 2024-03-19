class Scip < Formula
  desc "Solver for mixed integer programming and mixed integer nonlinear programming"
  homepage "https://scipopt.org"
  url "https://scipopt.org/download/release/scip-9.0.0.tgz"
  sha256 "b117a27cd4b62d3aa97a4bd0eaf06cbbd19a33a203b776599173a539085ed19f"
  license "Apache-2.0"

  livecheck do
    url "https://scipopt.org/scipdata.js"
    regex(/["']name["']:\s*?["']scip[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1613e0e61fad7535fa99ffcd84d8fcc50cc0129f199eec4694677f69bcfb9207"
    sha256 cellar: :any,                 arm64_ventura:  "c9b790b5a808f51d69aae738acf14ce1ffd8d21a38d6bb0e9a673dc6680b0ca6"
    sha256 cellar: :any,                 arm64_monterey: "991c0d33f2c999cb6331eee5790ef69a66792f3ca1cd71cc4944b8dbf9ef6c5d"
    sha256 cellar: :any,                 sonoma:         "bd989a806ad39acbb796f9f31d9ad9e0a8a8d95be5f378565818f91c3286e029"
    sha256 cellar: :any,                 ventura:        "da8e83d1efedfba851ab678f2ab9ab0c046a874438cedafc6e9fff5cfdee01a8"
    sha256 cellar: :any,                 monterey:       "5a5c8cb550e57e5eed5e78c4bb3cce5a8ac612cbd91e3f0d3de327235d24af7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed6b8ea13434faec0fa43aadece6838dd2b8c293355ddde883fbb8c787f86d01"
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
