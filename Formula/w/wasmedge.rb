class Wasmedge < Formula
  desc "Lightweight, high-performance, and extensible WebAssembly runtime"
  homepage "https://WasmEdge.org/"
  url "https://github.com/WasmEdge/WasmEdge/releases/download/0.16.1/WasmEdge-0.16.1-src.tar.gz"
  sha256 "fc256b8be022eb0487549cc2119c57fd12ad402e4130a05263b7aa85e2df89b9"
  license "Apache-2.0"
  head "https://github.com/WasmEdge/WasmEdge.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "17b4077e8280d81f8d20142527f6ff595553584b8e872defbbaeb35eb4c90b26"
    sha256 cellar: :any,                 arm64_sequoia: "6574474138284180a40d7611d6e216f9f7aa00e8063e74d847f675e7434606f3"
    sha256 cellar: :any,                 arm64_sonoma:  "55bd85f30c4d11db7ee8a32429dcdae83c0185c52fcb21d277ab9f6c093953f0"
    sha256 cellar: :any,                 sonoma:        "a01d8c8fe72f3fe00b2e6b23ff6a3f96e26d29b65bcb0e25eb34c21d12d3aad4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6774ab480d49e40c30811b4d182e2b223401e5f8714c5a4ed04c2a85c6df893c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7014a79a9395ab15fae21ccd420926891ced8f05a095bbc888852cbc46d9a8d8"
  end

  depends_on "cmake" => :build
  depends_on "fmt"
  depends_on "lld"
  depends_on "llvm"
  depends_on "spdlog"

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
