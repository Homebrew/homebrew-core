class Zxc < Formula
  desc "High-performance asymmetric lossless compression library"
  homepage "https://github.com/hellobertrand/zxc"
  url "https://github.com/hellobertrand/zxc/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "b589d2cabc4e577cb09a4faf18a7d787d93379db6918c7ae6e3cae4a07ba86bc"
  license "BSD-3-Clause"
  head "https://github.com/hellobertrand/zxc.git", branch: "main"

  bottle do
    manifest_sha256 "ed384586037a2e810e5e8084820abfe4a434f6dbce1aa205d9e20f88ade9bbca"
    sha256 cellar: :any, arm64_golden_gate: "6200b96b1516668005f245851c52114a7eb345a8ed9bdae88cf34b81661abf19"
    sha256 cellar: :any, arm64_tahoe:       "352578483db95087adde01f6cd14d7a0fda7b911e1fc14bb83806d43a69bf78d"
    sha256 cellar: :any, arm64_sequoia:     "98e3b4f22da122c50245d0300b1b48c6ff075981290d6a3cf8b1d061a473c9ea"
    sha256 cellar: :any, arm64_linux:       "be5c1f83b19a3ffc4a44bca642873d227f4c0f2c723b7c0d854a65e88f91f30b"
    sha256 cellar: :any, x86_64_linux:      "03e4b5762ce33328b9510398881096edb1a4f65a12275e88598fb1aa3a6eb32e"
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
