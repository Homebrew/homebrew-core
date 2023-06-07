class RaxmlNg < Formula
  desc "RAxML Next Generation: faster, easier-to-use and more flexible"
  homepage "https://sco.h-its.org/exelixis/web/software/raxml/"
  url "https://github.com/amkozlov/raxml-ng.git",
      tag:      "1.2.0",
      revision: "fd32e7f73c3ee44c526c7555a8d04e84b03bd51c"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5dd0d18757ed8322bf8672537cceeb471282fa9b04524e3fe8585c9f791afc37"
    sha256 cellar: :any,                 arm64_monterey: "cf0cb888b93104fffe0cced735061f7cf3a88979972dec9766c6a116368e1303"
    sha256 cellar: :any,                 arm64_big_sur:  "708f6103476f7b943910ecc3048537e44592c336e60a89c434eabed1b1794957"
    sha256 cellar: :any,                 ventura:        "2ea060156ee247a24ba70f338eb23d8a90563624f77418e7df55dc0586a05879"
    sha256 cellar: :any,                 monterey:       "f126aea85e829545d56f1632354e7e12de6e62bc9b72504f63a27fc938c9d40e"
    sha256 cellar: :any,                 big_sur:        "5a5a3ab547ff228ed8a5283ed133d2bbe498eeee5bd1735264977d6ef82b7526"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e69bccbc5f0a041d07a157481e885ed3bf94b31abf8d242f9313c5aa711ea14a"
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
