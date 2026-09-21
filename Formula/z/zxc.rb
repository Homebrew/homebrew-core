class Zxc < Formula
  desc "High-performance asymmetric lossless compression library"
  homepage "https://github.com/hellobertrand/zxc"
  url "https://github.com/hellobertrand/zxc/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "53744db7583231b03dc012b18880ea74b3a7060b58d411eed3694c9f521ceda3"
  license "BSD-3-Clause"
  head "https://github.com/hellobertrand/zxc.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "af8cb1954359f7d5fc1463e5e87e01a16ced553c86755206211a879684415912"
    sha256 cellar: :any, arm64_tahoe:       "e2e1bb2f3958fc5f7fe4ec5469f5354ae9371b8c57626cacce0b119fd597faca"
    sha256 cellar: :any, arm64_sequoia:     "2f30487e484f43f0f59ca343dfd1870546d252a92e4f2f480946f99d26a1e680"
    sha256 cellar: :any, arm64_linux:       "3bc4eb85e36121e2a6389c8d516186e0c9891b90ebd0e7303db9c646ca2a00bf"
    sha256 cellar: :any, x86_64_linux:      "1ae08cd0a78a506adae161745862cf01a70c39c1a22c166d93be8223ae57d763"
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
