class Zxc < Formula
  desc "High-performance asymmetric lossless compression library"
  homepage "https://github.com/hellobertrand/zxc"
  url "https://github.com/hellobertrand/zxc/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "57d7b5486d2d6a59c85a1de046db38f069af45725d1144986ab2b54c2811b09e"
  license "BSD-3-Clause"
  head "https://github.com/hellobertrand/zxc.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c24e5780ca401e2ef282af97b5f02f8cd57e71531ac3eb0d91e0a6d192efa6c3"
    sha256 cellar: :any, arm64_tahoe:       "6591ad4dca4a3945538b1f9ba368373742b031e35ba1dcc0ed5222c0711d5739"
    sha256 cellar: :any, arm64_sequoia:     "06a587508205d1af9a5a82e2813a357994e4d2cb0b58b92eb44910340fcab98b"
    sha256 cellar: :any, arm64_linux:       "180c94db6c376302393d59a32e027f9b68f76dd594369f8f0633d2662021747b"
    sha256 cellar: :any, x86_64_linux:      "00652597a5a27dcf9fb566af4ea44f94dbc40af23a2a9d26c8b34e2f2b899906"
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
