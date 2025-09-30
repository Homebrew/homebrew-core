class Scip < Formula
  desc "Solver for mixed integer programming and mixed integer nonlinear programming"
  homepage "https://scipopt.org"
  url "https://scipopt.org/download/release/scip-9.2.3.tgz"
  sha256 "6f5e81a643bba22d9b4e43cd97583529587c64eafe83b93bb864b07f9f16fab7"
  license "Apache-2.0"
  revision 1

  livecheck do
    url "https://scipopt.org/scipdata.js"
    regex(/["']name["']:\s*?["']scip[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f666e58ad2fbfe0dbffc7a58d211fa09df4179c1e16074de944d02654fae328e"
    sha256 cellar: :any,                 arm64_sequoia: "f8ff14375bbf116866a6f8d0917cd52845e5a37b5ec41c3304d0a8ceb04fcfc7"
    sha256 cellar: :any,                 arm64_sonoma:  "33d49db404f5b31e9b60f3cd5b2f8982499067d966971734e93088a9fbf67a05"
    sha256 cellar: :any,                 arm64_ventura: "89796a2888b7b4b4f7a0f2cd63ff585b4e99c040b6905f3c8c50e6cf26070542"
    sha256 cellar: :any,                 sonoma:        "512b6afc37693f78532bee21a11873c461d290e0b532c3194d1a4154596515ab"
    sha256 cellar: :any,                 ventura:       "ac57d89d437b828546d91953d235375a1c3d597e12e103b0ba8b858e2a009db5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae33e30f8a3e9f20cd5b9f86cf1ab15685d75a554487d3e1d071dab8bcc7539d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "473db25229bdb50611591dc03167ded5483485df70348d77c3870a09a1251292"
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
