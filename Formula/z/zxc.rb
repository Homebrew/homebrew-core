class Zxc < Formula
  desc "High-performance asymmetric lossless compression library"
  homepage "https://github.com/hellobertrand/zxc"
  url "https://github.com/hellobertrand/zxc/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "db8a1882bc1899a602d71b0b3f81995ef73162dbefe8c4b2a3f9f8b9f8b4b673"
  license "BSD-3-Clause"
  head "https://github.com/hellobertrand/zxc.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e1d2a3a80b681dcef7b78efbf4a5a99321ebcd3148050eefa9e4bc2fb69edf63"
    sha256 cellar: :any, arm64_sequoia: "1d5c2b8a17814e2929e9c28ef0f4ee1e750049403568199f76ae32bced25e5f8"
    sha256 cellar: :any, arm64_sonoma:  "bc7a53811fe4a89ae79f8380041e8bcaa76d9f6211e836b37b7a3d78f1c8bd73"
    sha256 cellar: :any, sonoma:        "28f3072a4bbb4af8164bce4e9060458e9b63d0b8008a2dc9c8ea9aa4e4e2b424"
    sha256 cellar: :any, arm64_linux:   "085e0a59f9d6e964a6d0ba309d064cb067483eace44f07b2f4eef7a30776ca37"
    sha256 cellar: :any, x86_64_linux:  "094314eefb5bbcf28fda5545166e23215378a90ba408ff8b8dcb2c6037fc5ec4"
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
