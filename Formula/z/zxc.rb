class Zxc < Formula
  desc "High-performance asymmetric lossless compression library"
  homepage "https://github.com/hellobertrand/zxc"
  url "https://github.com/hellobertrand/zxc/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "1af9ceb4e4ce881a3ff5a6fdbd19a43556a284888040a55f6a9bba68e85f529c"
  license "BSD-3-Clause"
  head "https://github.com/hellobertrand/zxc.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "19869ff1b580b880fd6d000a38a7749acfd7e23ad794aa92da66f14f636f1a05"
    sha256 cellar: :any, arm64_tahoe:       "30d99bb57a469a01116f2b91752c17a4fdc1a6cdcfc155d61a1cff783c80c6e9"
    sha256 cellar: :any, arm64_sequoia:     "c762c8a7c9e51fffa69a3e9ca025958fbb749a8bf6d170d589db11712f92f5c1"
    sha256 cellar: :any, arm64_linux:       "ac826a5c61244580dd9849e7227f6a7659e9aee6792d2f7430dd21c1a84fc8fa"
    sha256 cellar: :any, x86_64_linux:      "ed2949edc7a02da720972d3c6a67518d44131108aa7c5e77510c0aa90d331590"
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
