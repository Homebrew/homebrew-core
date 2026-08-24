class Wasmedge < Formula
  desc "Lightweight, high-performance, and extensible WebAssembly runtime"
  homepage "https://WasmEdge.org/"
  url "https://github.com/WasmEdge/WasmEdge/releases/download/0.17.1/WasmEdge-0.17.1-src.tar.gz"
  sha256 "c8881a8c43407fc424ccd8586594a79068305b31c76aad0025efea9339be18e0"
  license "Apache-2.0"
  head "https://github.com/WasmEdge/WasmEdge.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "bdcf3dfe45787e3b26fff39e6904749235a5405f43b9ae9aa89de5541b45aeaa"
    sha256 cellar: :any, arm64_sequoia: "07fdf1d688038e092367145e7c595382575f82b8ba7f88476745912daac5c4bd"
    sha256 cellar: :any, arm64_sonoma:  "04137e8e1a6fca57ae512f30d864bbea37e65fc4ec8eb97c3c5c00d02f655a0a"
    sha256 cellar: :any, sonoma:        "96680ea11a613cc7a9b63dbd4d483f8692dc737d322c799c5bfb2dad82ef1ec4"
    sha256 cellar: :any, arm64_linux:   "476837e2f7dd04a1e1a0ef87ca38d39317d76301e33f1857f28b679008cce10d"
    sha256 cellar: :any, x86_64_linux:  "7d5a375e9b4b4823aa289ca9030b036621ddfe8e5483476506928897f74bc524"
  end

  depends_on "cmake" => :build
  depends_on "fmt"
  depends_on "lld"
  depends_on "llvm"
  depends_on "spdlog"

  # fmt 12.2 dropped operator~ on uint128_fallback; upstream fix not in 0.17.1.
  patch do
    url "https://github.com/WasmEdge/WasmEdge/commit/41a01b6b4f40defbac0dd551663c542cdcf9ae76.patch?full_index=1"
    sha256 "55657c3a628a406b655ba224019f0121f2489140dca128c3f8c623c019de84b1"
    type :backport
    resolves "https://github.com/WasmEdge/WasmEdge/pull/4936"
  end

  def install
    # Use CMAKE_BUILD_WITH_INSTALL_RPATH to keep versioned LLVM in RPATH on Linux
    args = ["-DCMAKE_BUILD_WITH_INSTALL_RPATH=ON"] if OS.linux?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # sum.wasm was taken from wasmer.rb
    wasm = ["0061736d0100000001070160027f7f017f030201000707010373756d00000a09010700200020016a0b"].pack("H*")
    (testpath/"sum.wasm").write(wasm)
    assert_equal "3\n",
      shell_output("#{bin}/wasmedge --reactor #{testpath/"sum.wasm"} sum 1 2")
  end
end
