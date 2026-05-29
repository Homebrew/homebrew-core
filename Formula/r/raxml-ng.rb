class RaxmlNg < Formula
  desc "RAxML Next Generation: faster, easier-to-use and more flexible"
  homepage "https://cme.h-its.org/exelixis/web/software/raxml/"
  url "https://github.com/amkozlov/raxml-ng.git",
      tag:      "2.0.1",
      revision: "a7d61b56d2e0e6e263e4686bcbd0017659b37711"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a448506aeb79b7723b901babc8957c55ccd8f7140ed2cea884056b7c0cbaa41"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7d87c78f2854133816e3df16ea36882138413ccab5c36933fa530c7897f9677"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3cf4a28e7921d618f72ef37ec17b9a22f159921468544873686b7656fa4091da"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3cb8b87825f9482378ea6448b11c712bff87b5739428605b66ca2586ab1f2df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a03b4f5f5f3df34d530934a4e3bd3e2097e73c76030c5c9fbc902d546340f822"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3df42702cd7ab6b0f56fa527b8c88e6431a9194261d779da62c7e6b707f7ffb0"
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
