class Wasmedge < Formula
  desc "Lightweight, high-performance, and extensible WebAssembly runtime"
  homepage "https://WasmEdge.org/"
  url "https://github.com/WasmEdge/WasmEdge/releases/download/0.13.5/WasmEdge-0.13.5-src.tar.gz"
  sha256 "95e066661c9fc00c2927e6ae79cb0d3f9c38e804834c07faf4ceb72c0c7ff09f"
  license "Apache-2.0"
  head "https://github.com/WasmEdge/WasmEdge.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "33e4ce1d41249590d70302bd71f0a3469e524bcbe3a712cc86d030b813dfb69a"
    sha256 cellar: :any,                 arm64_ventura:  "0d80f3e14880d7c8f8ee50b3425872c68207b1be37b0ca270e1f9aeefbdad40d"
    sha256 cellar: :any,                 arm64_monterey: "b73d8b824a1d2b0e5b045757a1897a49a78b31bc02e9a7f661fcaa783e5c7d5d"
    sha256 cellar: :any,                 sonoma:         "63743fc9c1603e88e48a19d5d73107984273488f6b94cb03763183964b38ff61"
    sha256 cellar: :any,                 ventura:        "cf190b3d7868fdfc6112b1e2850d74cfa98799bc009402d8a6c2dd4d1671e261"
    sha256 cellar: :any,                 monterey:       "966e885668dea37e7868a57fbdf12dfff7d3a4f79bf341ebd6157084b06ded4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0cbc06f9de75c3ca9c748d99a08eb5ec01ffd8cf003b51a6312b71c500a0cebc"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  # llvm is required on run-time, as WASMEDGE_LINK_LLVM_STATIC defaults to OFF.
  # The version is pinned to 16 due to https://github.com/WasmEdge/WasmEdge/pull/2878
  depends_on "llvm@16"

  def install
    ENV["LLVM_DIR"] = Formula["llvm@16"].opt_lib/"cmake"
    ENV["CC"] = Formula["llvm@16"].opt_bin/"clang"
    ENV["CXX"] = Formula["llvm@16"].opt_bin/"clang++"
    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja", *std_cmake_args
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
