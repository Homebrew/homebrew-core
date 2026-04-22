class Zxc < Formula
  desc "High-performance asymmetric lossless compression library"
  homepage "https://github.com/hellobertrand/zxc"
  url "https://github.com/hellobertrand/zxc/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "35f648b282495c470c706375a5430c0d7261ae36e5ce03863d9e02f8907e49de"
  license "BSD-3-Clause"
  head "https://github.com/hellobertrand/zxc.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5958f2a947f570fbf8a66bceb77be5ce0413cb8346688899797c9ca4e1dbf738"
    sha256 cellar: :any,                 arm64_sequoia: "70a8e36f1264e02c5eb3d317bb87df7b8c8b7f3de55aea0cd55418f8b3383e5c"
    sha256 cellar: :any,                 arm64_sonoma:  "608c75310b153a7bf9e517f4f39ed151d295196af1ae5e7f0776eeb7e1a82875"
    sha256 cellar: :any,                 sonoma:        "619f0a98421172213480b2fab06ff04f9ec2d44dde7f732d6fa7c6b0142a569c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5df961a0e893696d75ff0bfd8b6040015f45ea645830f9399389afa9484edd7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c411e5e1f190b3029466c8f32d5ce16a1cac7048865ec2a6a0e266380f3ae238"
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
