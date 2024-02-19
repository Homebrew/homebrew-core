class RaxmlNg < Formula
  desc "RAxML Next Generation: faster, easier-to-use and more flexible"
  homepage "https://sco.h-its.org/exelixis/web/software/raxml/"
  url "https://github.com/amkozlov/raxml-ng.git",
      tag:      "1.2.1",
      revision: "af74065fa2e03d4eb3efd83881bd50926d07e234"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "dcf2e94a38e1026c97cd3c6eea1cbf216a6d7209cad9b7ed67de4a1f8707fbb7"
    sha256 cellar: :any,                 arm64_ventura:  "e2ece52151cf1a3c156da7d2dfe5298d2141792abf159fb04c399bc323aa9474"
    sha256 cellar: :any,                 arm64_monterey: "e4b6c4593160a8ba0cbe421e9fda4df960aac50583897ce435f5295a4675396e"
    sha256 cellar: :any,                 sonoma:         "ab64dbd6f9c0abc354924c3e5ff92d3900f1c4cde7e30ca1d18a5bc12d23f70f"
    sha256 cellar: :any,                 ventura:        "22c88c983900ec464ca890567fa71d692ebe082600f2663117c48a583cb01678"
    sha256 cellar: :any,                 monterey:       "c63dce9f7ba5dcb10bb58cfb09e6ea097246ec5380e20ae5159ed237af33f778"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eab1309c5fad5a6369cddfc221afce7f9c32a943778afd32c4d9f3641ac015c6"
  end

  depends_on "bison" => :build # fix syntax error with `parse_utree.y`
  depends_on "cmake" => :build
  depends_on "gmp"

  uses_from_macos "flex" => :build

  on_linux do
    depends_on "open-mpi"
  end

  resource "homebrew-example" do
    url "https://sco.h-its.org/exelixis/resource/download/hands-on/dna.phy"
    sha256 "c2adc42823313831b97af76b3b1503b84573f10d9d0d563be5815cde0effe0c2"
  end

  def install
    args = std_cmake_args + ["-DUSE_GMP=ON"]
    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Upstream doesn't support building MPI variant on macOS.
    # The build ignores USE_MPI=ON and forces ENABLE_MPI=OFF.
    # This causes necessary flags like -D_RAXML_MPI to not get set.
    return if OS.mac?

    system "cmake", "-S", ".", "-B", "build_mpi", *args, "-DUSE_MPI=ON"
    system "cmake", "--build", "build_mpi"
    system "cmake", "--install", "build_mpi"
  end

  test do
    testpath.install resource("homebrew-example")
    system bin/"raxml-ng", "--msa", "dna.phy", "--start", "--model", "GTR"
  end
end
