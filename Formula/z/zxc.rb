class Zxc < Formula
  desc "High-performance asymmetric lossless compression library"
  homepage "https://github.com/hellobertrand/zxc"
  url "https://github.com/hellobertrand/zxc/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "8d2e7dde310624a67c14247c21b0188bffc0a8041e012888d9dd7adac45e66aa"
  license "BSD-3-Clause"
  head "https://github.com/hellobertrand/zxc.git", branch: "main"

  bottle do
    manifest_sha256 "a64d699a1aacda06c93b20f1e2ae1843df0377f58e2737d376df590851b5a5a3"
    sha256 cellar: :any, arm64_golden_gate: "9c56f6767c440f28dd5c6aefc7291ed43e9debc7d31896988e42aeb0344bef6b"
    sha256 cellar: :any, arm64_tahoe:       "f8c0bcc15ed26bf4d0bb9c4c318793e4024eeff1668adffa1d523a4b2b922002"
    sha256 cellar: :any, arm64_sequoia:     "866efd2057149425ad941fdd2f643cc6cfaa2279f19b34e07af450a51bd0f477"
    sha256 cellar: :any, arm64_linux:       "038b84a48d88f396ac17b3ef38d0ed3d9e1570c71cba6719f145d91e3522e115"
    sha256 cellar: :any, x86_64_linux:      "6ddf538f4d383b8c9372ea0c9548e9ea0cbec1f0959af553052848a5d5c0a875"
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
