class RaxmlNg < Formula
  desc "RAxML Next Generation: faster, easier-to-use and more flexible"
  homepage "https://cme.h-its.org/exelixis/web/software/raxml/"
  url "https://github.com/amkozlov/raxml-ng.git",
      tag:      "2.0.3",
      revision: "173b012f9989bfdd53970e6917e4037be3d1e38e"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e3daac436d4260054c5156e06a738d455d5f5a44aa02f0797836576248e3adc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aea14622d563b842321e5ec82872068ece318b362fd1b0e95cb095ce68c4af6d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e0cf799c98ad64e2e0bde18b42eec8ac745bb49669770e2e35ae9ec0eac8067"
    sha256 cellar: :any,                 arm64_linux:   "4407b9c62cad4c48cec8be7c16fcf45315fe80b3bc97f162ca20b4689946ec3f"
    sha256 cellar: :any,                 x86_64_linux:  "562298904931702903798d2f2a093e7db60eabe4b09a735e221169f020fd6952"
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
    if Hardware::CPU.arm?
      # `PORTABLE_BUILD=ON` still enables x86 SIMD paths on macOS arm64,
      # upstream issue ref, https://github.com/amkozlov/raxml-ng/issues/226.
      args << "-DPORTABLE_BUILD=ON"
      args += %w[
        -DCORAX_ENABLE_SSE=OFF
        -DCORAX_ENABLE_AVX=OFF
        -DCORAX_ENABLE_AVX2=OFF
      ]
    end

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
    # `--start` fails with missing `startTree` output on 2.0.0,
    # upstream issue ref, https://github.com/amkozlov/raxml-ng/issues/227.
    system bin/"raxml-ng", "--parse", "--msa", "dna.phy", "--model", "GTR"
    assert_path_exists testpath/"dna.phy.raxml.rba"
  end
end
