class Scip < Formula
  desc "Solver for mixed integer programming and mixed integer nonlinear programming"
  homepage "https://scipopt.org"
  url "https://scipopt.org/download/release/scip-9.0.1.tgz"
  sha256 "83e353a7a2c125d19a0da760ae1087a3e418b673a8ee17494afac3ad84e0a797"
  license "Apache-2.0"

  livecheck do
    url "https://scipopt.org/scipdata.js"
    regex(/["']name["']:\s*?["']scip[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6ecfd6e11a65972d4919916f94571f71140950a6539ccace515e8ae6ad0988fb"
    sha256 cellar: :any,                 arm64_ventura:  "edd1d4e32c191ed7e7244837fadb13c89376f5052c9f3147744bd90096c7d16f"
    sha256 cellar: :any,                 arm64_monterey: "1a8f452ef1612a00034269c5610a9af7b77ad2942026bfcec9df95d1c595f898"
    sha256 cellar: :any,                 sonoma:         "516e748c04152edeb228af82bc03e28abb9c34148648c34a9153f185a051f512"
    sha256 cellar: :any,                 ventura:        "8d0c5b53900521d8206898a102b2de7dbf0fdd686cb36f97f9361834ed7a98de"
    sha256 cellar: :any,                 monterey:       "d0a0f5588156d728304209bf5f62d37721ef38218e9ed8b02424d523109dad93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08ca46c84a7d447628fc7388a82c59a8d53b0eeb0b070ede8689339acdd70289"
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
