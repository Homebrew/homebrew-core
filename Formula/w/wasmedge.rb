class Wasmedge < Formula
  desc "Lightweight, high-performance, and extensible WebAssembly runtime"
  homepage "https://WasmEdge.org/"
  url "https://github.com/WasmEdge/WasmEdge/releases/download/0.18.0/WasmEdge-0.18.0-src.tar.gz"
  sha256 "c3ef59723d8e5e09021bb9ed7ec55c596b33969b95bc1fbfb0ce1d21075e061e"
  license "Apache-2.0"
  head "https://github.com/WasmEdge/WasmEdge.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "9548f79a45b648137812e1358c9f1bc2f789a3f61f2eacb164a9d62d237083a7"
    sha256 cellar: :any, arm64_tahoe:       "3cb76e163197b6aa463d70cf0c099cc9407df836e4d939e77c502f466d98a38a"
    sha256 cellar: :any, arm64_sequoia:     "c8c44ef675c22f2836b227784f4215027f4bcf76106a2553e2a79ccfb7c2de98"
    sha256 cellar: :any, arm64_linux:       "580c75afe4a9b6e2017579eaa2a8ebffeb2660a8332557fde934aae08b59232c"
    sha256 cellar: :any, x86_64_linux:      "ff560c0fe6851344dcf8c66b7301debb14824f8ac8575a605c96823118f0eaf3"
  end

  depends_on "cmake" => :build
  depends_on "fmt"
  depends_on "lld"
  depends_on "llvm"
  depends_on "spdlog"

  # fmt 12.2 dropped operator~ on uint128_fallback; upstream fix not in 0.17.1.

  deny_network_access!

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
