class Zxc < Formula
  desc "High-performance asymmetric lossless compression library"
  homepage "https://github.com/hellobertrand/zxc"
  url "https://github.com/hellobertrand/zxc/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "a8e82e811aca54ca3c2f8b27e1184e795826ae87981e255d36630a6924ece202"
  license "BSD-3-Clause"
  head "https://github.com/hellobertrand/zxc.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8fbd5c1f1f9020ad8cfce4e9cc707e8c66f8b45121a133cfa0f57d4c0836a026"
    sha256 cellar: :any,                 arm64_sequoia: "5385b148dfe5e631df5a5361a65433061b0306283a37eb444a8f1345c39c23f5"
    sha256 cellar: :any,                 arm64_sonoma:  "6c415e06a5180027ca519c2d9b72e4fe45aab71647ff98f334bf8b84efad7f26"
    sha256 cellar: :any,                 sonoma:        "dd75aa0998af77a4dbf6ea9bdc3bc22b028c75b3da97c22dcf2f874e7f7cd296"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f49490371f19c39f4801c7164a6c39545c8e26f27cd3042124b47cf9f81dcd41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee15464079ff409d2915a4af3f665202753151641c9226b52553c5cc0a4958b8"
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
