class Wasmedge < Formula
  desc "Lightweight, high-performance, and extensible WebAssembly runtime"
  homepage "https://WasmEdge.org/"
  url "https://github.com/WasmEdge/WasmEdge/releases/download/0.14.0/WasmEdge-0.14.0-src.tar.gz"
  sha256 "3fc518c172329d128ab41671b86e3de0544bcaacdec9c9b47bfc4ce8b421dfd5"
  license "Apache-2.0"
  head "https://github.com/WasmEdge/WasmEdge.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "399f976e480353393923067c0edf8f3a9f0312181f6bc2ccbb469290a9e5480e"
    sha256 cellar: :any,                 arm64_ventura:  "4674f87387d665ff79cc83537e29d9df1998e1e954bd7021e4d63e737e031feb"
    sha256 cellar: :any,                 arm64_monterey: "6bb1b7caa562838c0a114d7705c3307a0eeb23c4fa535d59472b6c0e1d67b37d"
    sha256 cellar: :any,                 sonoma:         "22c2e0bdd12b8221f50244e35671fe74822e6395fe40dcc210a2ee76f121f195"
    sha256 cellar: :any,                 ventura:        "d6a8fa17e8f865eb722879534f76e30efb22cda34cbe8d9ef44f5b8c3608f298"
    sha256 cellar: :any,                 monterey:       "4f17e4c8f22379c119c7a256bad3298dac9fb618cdcd21841b3dcaabb9ea09fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55740f2580c4903debfe3e6882e5080aeb70f56387123b201437e5c74d92b3b9"
  end

  depends_on "cmake" => :build
  depends_on "fmt"
  depends_on "llvm"
  depends_on "spdlog"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
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
