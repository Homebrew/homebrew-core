class RaxmlNg < Formula
  desc "RAxML Next Generation: faster, easier-to-use and more flexible"
  homepage "https://cme.h-its.org/exelixis/web/software/raxml/"
  url "https://github.com/amkozlov/raxml-ng.git",
      tag:      "1.2.2",
      revision: "805318cef87bd5d67064efa299b5d1cf948367fd"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "c74c9931e040c4511002c51f6828473eb44842300ce6f4aab7052279d156b0ca"
    sha256 cellar: :any,                 arm64_sequoia:  "4f7e500c5a3615a4c814bf38bd8720a745c4155827910f4cd5638113e129d2c6"
    sha256 cellar: :any,                 arm64_sonoma:   "bd6bd94ccee20b21d5c9146a8bc4a484c261a11586224ec4303a2d269590b32f"
    sha256 cellar: :any,                 arm64_ventura:  "6fcf4ec42def10fd485108f16f3d9c03f59f06ff72b663e469d7985332b99222"
    sha256 cellar: :any,                 arm64_monterey: "a2e435fabdb95292270d576aa6fd6dceda14ad722cd12ccb916371b8aa01e0a4"
    sha256 cellar: :any,                 sonoma:         "63100f2fe0b660b831fcb16cc08b299bf62a978d4c97949d87d5e09716b4670d"
    sha256 cellar: :any,                 ventura:        "456c5f39dacdc8ce957c17d67f53410977c8217bc98ca45ba97c1df187442aa9"
    sha256 cellar: :any,                 monterey:       "7bbd86f8a89f92287d21cab56e055333a5c5ec90e955b76f78d3c8a36cb9dda4"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "9aa9f1417b9bf4ed64b5e690d2a6901d5c181cc9fd8e641589301b8118d2ab1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53e258a6db4cb2d05aa6013741ac3c2345a9d92da103a23d34dda647b8e8d532"
  end

  depends_on "bison" => :build # fix syntax error with `parse_utree.y`
  depends_on "cmake" => :build
  depends_on "gmp"

  uses_from_macos "flex" => :build

  on_linux do
    depends_on "open-mpi"
  end

  def install
    args = %w[-DUSE_GMP=ON]
    # Workaround to build with CMake 4
    args << "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Upstream doesn't support building MPI variant on macOS.
    # The build ignores USE_MPI=ON and forces ENABLE_MPI=OFF.
    # This causes necessary flags like -D_RAXML_MPI to not get set.
    return if OS.mac?

    args << "-DUSE_MPI=ON"
    system "cmake", "-S", ".", "-B", "build_mpi", *args, *std_cmake_args
    system "cmake", "--build", "build_mpi"
    system "cmake", "--install", "build_mpi"
  end

  test do
    resource "homebrew-example" do
      url "https://cme.h-its.org/exelixis/resource/download/hands-on/dna.phy"
      sha256 "c2adc42823313831b97af76b3b1503b84573f10d9d0d563be5815cde0effe0c2"
    end

    testpath.install resource("homebrew-example")
    system bin/"raxml-ng", "--msa", "dna.phy", "--start", "--model", "GTR"
  end
end
