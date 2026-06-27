class Zxc < Formula
  desc "High-performance asymmetric lossless compression library"
  homepage "https://github.com/hellobertrand/zxc"
  url "https://github.com/hellobertrand/zxc/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "2de4e21a4ecb33a71ba04b052b94d4e4f9882c85851d2142863f8629a9e06623"
  license "BSD-3-Clause"
  head "https://github.com/hellobertrand/zxc.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "13314f64a4459c3dc06d9461b9c23a2d3996c3539bd07f1c88f57511b2efa9b6"
    sha256 cellar: :any, arm64_sequoia: "8e7279fd55f7b5ad868646124261d7833f90e402ff28794312e7e4981144b8d2"
    sha256 cellar: :any, arm64_sonoma:  "00257a43d833351db8bd82563e8d6fed67f3d3ed8ec51430d5f5e3e756dcfda9"
    sha256 cellar: :any, sonoma:        "4a2a65db64bf5da38f423fb98892cc08469058bb6a2b2c0d346e3de6d24d9846"
    sha256 cellar: :any, arm64_linux:   "7a8281beae3432f1601dec42e96f19bd301f5a2a87ab143a2598c1dbdd6e6ef6"
    sha256 cellar: :any, x86_64_linux:  "b70401e9c15c5abf8c4fa2ce99a68bd37efe54f26272aea29f68ee04a85e9f91"
  end

  depends_on "cmake" => :build

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
