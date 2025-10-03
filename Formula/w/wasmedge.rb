class Wasmedge < Formula
  desc "Lightweight, high-performance, and extensible WebAssembly runtime"
  homepage "https://WasmEdge.org/"
  license "Apache-2.0"
  revision 1
  head "https://github.com/WasmEdge/WasmEdge.git", branch: "master"

  stable do
    url "https://github.com/WasmEdge/WasmEdge/releases/download/0.15.0/WasmEdge-0.15.0-src.tar.gz"
    sha256 "17915c4d047bc7a02aca862f4852101ec8d35baab7b659593687ab8c84b00938"

    # Backport support for LLVM 21
    patch do
      url "https://github.com/WasmEdge/WasmEdge/commit/b11791e4312445e3fd2d6c56acc9c2e36e12ef34.patch?full_index=1"
      sha256 "f9d3b39ca9871ca3d2c87f7e107651d36e9eedeccc79925879671ff552aec99b"
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "cae2cd202250f8a1284cc3c7f4e6991f0b6ac3c138210a0ec9dd1fb0f0f5afb4"
    sha256 cellar: :any,                 arm64_sequoia: "d42fe39e5a2f3b8453ea3ff350fdbe0f9805d525f6f2efa6272d3fe65bdb3800"
    sha256 cellar: :any,                 arm64_sonoma:  "5b40a4f9669a493b8d16475cf0157141d39379ed2fc2c7366223fd1efe072ba1"
    sha256 cellar: :any,                 sonoma:        "2f335b6c00bea0f23795a48d5f0bcd3163bf93dc232d9ad9181932cbe10b2aaf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e1d0a80bf156603ed138c859d3d7f7725fc49c293ac6f7c7bd460dcdff1d7ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07e7399f0cca85682d66383298f69843f12b3adb3fa0518eb5d6f9bc7b884eaa"
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
