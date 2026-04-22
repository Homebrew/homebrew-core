class RaxmlNg < Formula
  desc "RAxML Next Generation: faster, easier-to-use and more flexible"
  homepage "https://cme.h-its.org/exelixis/web/software/raxml/"
  url "https://github.com/amkozlov/raxml-ng.git",
      tag:      "2.0.0",
      revision: "e995a54dda83e440ee15e890093c5b2718787043"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "23abe5b75f51e9b192e090d5d0be80e45ad5c19c5aa1ec54f7ff0a6113d81e22"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c06b5319a7877e62e01d672e18ca8abdedf402f1eafce1a8d3fcd26bd9ba85e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb756e6e32e613f364dbc9c72b6be954cd98935c6faf99162172a5e2dab84211"
    sha256 cellar: :any_skip_relocation, sonoma:        "285955dfad46130dd32556aa964f7edb2e6a1f1fbed29ecc58347d3eebb58ec3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d549b9dfd0c03f3c39a19a1aa640da905b0ed71360d69cbee11f14a9ebc4e1c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e73be7c74afaab314353cc6bcc1e2fa5a76a7f1347ca789f4cde39efe260b34e"
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
