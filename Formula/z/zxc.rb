class Zxc < Formula
  desc "High-performance asymmetric lossless compression library"
  homepage "https://github.com/hellobertrand/zxc"
  url "https://github.com/hellobertrand/zxc/archive/refs/tags/v0.13.3.tar.gz"
  sha256 "46ff1c9f8c78c19cd891abbbf15b80025f6bbcedd515ddb6ce6c8d91175b5653"
  license "BSD-3-Clause"
  head "https://github.com/hellobertrand/zxc.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "dfb2091d0a14bffdecd23c1ea1a1dc36f95a3db4db728e3988f56ed5d2567754"
    sha256 cellar: :any, arm64_sequoia: "c0fd5f7e3c32082394a1b97d40126dc61437e30ea46b5126cf581d22b346bff2"
    sha256 cellar: :any, arm64_sonoma:  "6501de9e41cbc017805de3ed0e47666c9746413292dbc81bb31344fe171f24cf"
    sha256 cellar: :any, sonoma:        "5821d8a0040205d0ff87fb7122861d344e2a436b3f88ee836a3b7f2b477a0ecf"
    sha256 cellar: :any, arm64_linux:   "5574e184949f399e9acc1a221ebbab1074238f6b00ffd9c5504a27b45c9b000e"
    sha256 cellar: :any, x86_64_linux:  "e90c19ceb7d648428b99a3a1a2dfe9891a38fbc1594d1e636dda2d9af8945008"
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
