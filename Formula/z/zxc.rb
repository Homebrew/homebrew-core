class Zxc < Formula
  desc "High-performance asymmetric lossless compression library"
  homepage "https://github.com/hellobertrand/zxc"
  url "https://github.com/hellobertrand/zxc/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "dc33dfc9ab911f37d9e79f87c883955961f4b014fe07b3862dac028c077881b0"
  license "BSD-3-Clause"
  head "https://github.com/hellobertrand/zxc.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b42deb1676cf397dd6c9e7ee0beb4b1450b0e0f191ccdb559cbd316dccddfa68"
    sha256 cellar: :any, arm64_sequoia: "b44f1e509113704c756657ba427be4133e277b614d29e55d8ae41385df4c7f15"
    sha256 cellar: :any, arm64_sonoma:  "c164d188f57eed7532c448efe4f01b6fbc1cf80b79afa6a7cd5bc2a9f7554dd2"
    sha256 cellar: :any, arm64_linux:   "7475d4beae09c4a0f6bd74afa1e74e0ab95431f4c9c3c53bb5ed65e86d340cfa"
    sha256 cellar: :any, x86_64_linux:  "40765bbb28465a91093344f169997889e98e826a015bdddc1a885c6cd99a6564"
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
