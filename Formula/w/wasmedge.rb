class Wasmedge < Formula
  desc "Lightweight, high-performance, and extensible WebAssembly runtime"
  homepage "https://WasmEdge.org/"
  license "Apache-2.0"
  revision 2
  head "https://github.com/WasmEdge/WasmEdge.git", branch: "master"

  stable do
    url "https://github.com/WasmEdge/WasmEdge/releases/download/0.14.1/WasmEdge-0.14.1-src.tar.gz"
    sha256 "e5a944975fb949ecda73d6fe80a86507deb2d0a221b2274338807b63758350b4"

    # Backport fix for LLVM 20
    patch do
      url "https://github.com/WasmEdge/WasmEdge/commit/b63e201d46452453ee7c2acf07967cd292d7e3da.patch?full_index=1"
      sha256 "5c7f335ef8c126fc7791c289eb9c53527e1649388eb6e160e524c4d756122eb0"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "67f798b7219084dfa14096a1c91974f1252b3aa90b774292a4b2b09c9d257da9"
    sha256 cellar: :any,                 arm64_sonoma:  "e40488c2a5a64616f0abdad4e86056e67b417d46dd253deee1f9e8072a8b1be5"
    sha256 cellar: :any,                 arm64_ventura: "0cf792cb183a9c9089f4ba8166565eb30d034fa8ec80e533a1121bc16151ff2e"
    sha256 cellar: :any,                 sonoma:        "f6aef7a20301de5044988aed305a9514758f450919daa23b69d8d6eaf09038ff"
    sha256 cellar: :any,                 ventura:       "1583bcaef8c69487b45ec5a4e5c0b77161e54a8f8e50cd30ab157d8c155b0520"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "549aa7b97ccf0598a95b28c22515de2eb75f27cd33bafb8d586ba929417becdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78bc000a274f42631d0fdedbfa43a93c06522a929bb15ee3008cb460310045ff"
  end

  depends_on "cmake" => :build
  depends_on "fmt"
  depends_on "lld"
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
