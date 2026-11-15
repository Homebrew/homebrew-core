class RaxmlNg < Formula
  desc "RAxML Next Generation: faster, easier-to-use and more flexible"
  homepage "https://cme.h-its.org/exelixis/web/software/raxml/"
  url "https://github.com/amkozlov/raxml-ng.git",
      tag:      "2.0.4",
      revision: "c6e3e1f42597d9b167de1d887050df2994c9207b"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "69f538593adc3d032ee4e3177b4aef428669606b8b493e297a3d942d25fdc176"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "73dd969d016e8229cabb33eca14a519dc8499fea54dc8776676b6b4b7f676970"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f61e3237c383b35063a5f24ac1093bca22cf47d1111bc94c9ae05bf0b7e39ae6"
    sha256 cellar: :any,                 arm64_linux:       "049f2b0bd2f3180278c7f22fd6d70a743d409f827a3ea701230c562a7c3ecfa7"
    sha256 cellar: :any,                 x86_64_linux:      "35ee1827b72a447166d1757cfbb4fff2ec540994102de494d441c77e5dcfe1c0"
  end

  depends_on "bison" => :build # fix syntax error with `parse_utree.y`
  depends_on "cmake" => :build
  depends_on "gmp"

  uses_from_macos "flex" => :build

  on_linux do
    depends_on "open-mpi"
  end

  resource "homebrew-example", :test do
    url "https://cme.h-its.org/exelixis/resource/download/hands-on/dna.phy"
    sha256 "c2adc42823313831b97af76b3b1503b84573f10d9d0d563be5815cde0effe0c2"
  end

  allow_network_access! :test

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
    testpath.install resource("homebrew-example")
    # `--start` fails with missing `startTree` output on 2.0.0,
    # upstream issue ref, https://github.com/amkozlov/raxml-ng/issues/227.
    system bin/"raxml-ng", "--parse", "--msa", "dna.phy", "--model", "GTR"
    assert_path_exists testpath/"dna.phy.raxml.rba"
  end
end
