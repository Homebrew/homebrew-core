class Zxc < Formula
  desc "High-performance asymmetric lossless compression library"
  homepage "https://github.com/hellobertrand/zxc"
  url "https://github.com/hellobertrand/zxc/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "1af49a9d40e644740dca75f176c03535e123f6d0ba81833552b77a70e6eeabaa"
  license "BSD-3-Clause"
  head "https://github.com/hellobertrand/zxc.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b83ab7b7f5ac6dc6e1383d70f1221aba5fdba3117e17d2fb9ce3db93c1a329c0"
    sha256 cellar: :any, arm64_tahoe:       "83d44707240783cbd0dae015cc8bb484a6583e4982d4984122f574b955aaa28c"
    sha256 cellar: :any, arm64_sequoia:     "075e9c4cbd264f2e33ab482556e971062d73cff69c944f84f2f41b88917eb085"
    sha256 cellar: :any, arm64_linux:       "527dddd1118ae3530f3287de91ccfa6042891c5fbfc5680eb717906498bc1e1d"
    sha256 cellar: :any, x86_64_linux:      "64f5d179a9bd60d2b6975f8057c73aaadb3eb94539f0c9790576c1f5d6176d19"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DZXC_NATIVE_ARCH=OFF
      -DZXC_BUILD_TESTS=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    input = "Hello world"
    compressed = pipe_output(bin/"zxc", input)
    refute_empty compressed
    decompressed = pipe_output("#{bin}/zxc -d", compressed)
    assert_equal input, decompressed
  end
end
