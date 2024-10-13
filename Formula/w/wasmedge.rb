class Wasmedge < Formula
  desc "Lightweight, high-performance, and extensible WebAssembly runtime"
  homepage "https://WasmEdge.org/"
  url "https://github.com/WasmEdge/WasmEdge/releases/download/0.14.1/WasmEdge-0.14.1-src.tar.gz"
  sha256 "e5a944975fb949ecda73d6fe80a86507deb2d0a221b2274338807b63758350b4"
  license "Apache-2.0"
  head "https://github.com/WasmEdge/WasmEdge.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a693459d38049adbf9cb43699facc22a13e6a784071fd0167f9d8dbde15d0342"
    sha256 cellar: :any,                 arm64_sonoma:  "64a272c92a5f2e25cecbd3df9ecc9b7032eb4319e20473de1ff818dedb0b882e"
    sha256 cellar: :any,                 arm64_ventura: "ec30d58b059463024d7c2837d585aeb6c785e5ec5efbe7cbb66673095085e2c8"
    sha256 cellar: :any,                 sonoma:        "94bee0da6e4d65de8a4cfe093ffffe65e36e217f062e162e4d5288e7c8c46d54"
    sha256 cellar: :any,                 ventura:       "e3a3b9b1a8f8892869188b072ac3b39eec17fdbcb37ead5298daecde9062da7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ae2b2152cf63e8e71604973052596aed2a77d5de08a8959135eae1c8321a703"
  end

  depends_on "cmake" => :build
  depends_on "fmt"
  depends_on "llvm"
  depends_on "spdlog"

  uses_from_macos "zlib"

  on_linux do
    depends_on "zstd"
  end

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
