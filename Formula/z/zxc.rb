class Zxc < Formula
  desc "High-performance asymmetric lossless compression library"
  homepage "https://github.com/hellobertrand/zxc"
  url "https://github.com/hellobertrand/zxc/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "7abc810bb923dd3b1ed729b34fe78c4b3b39b427c118c5a567d7a033995422ed"
  license "BSD-3-Clause"
  head "https://github.com/hellobertrand/zxc.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c717bcb1fae12feb01b74627f9008f5b9469b8040ba11b0af2be605b240fc5a7"
    sha256 cellar: :any,                 arm64_sequoia: "0141992b3a6f39ff42ff5a4c30bbb903b384e5e0c1e3885bc4b5ef8969e6101d"
    sha256 cellar: :any,                 arm64_sonoma:  "8418c0eb4df64947056ccf78ed8eaa7c950e06eb858ad10d66e13bb4a16ff057"
    sha256 cellar: :any,                 sonoma:        "976fe6dea8665e7b13b7e20466ea5930f13436c79899fd879a104699b87a9399"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "21603f00acbb6ca16b9e300c3571116f059e3c005ef7903780b844d7bca1a998"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1205eb073e25e6856361b37530ba1fef1bbcc5a713142193a0d2e824d8ea6471"
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
