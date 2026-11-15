class Wasmedge < Formula
  desc "Lightweight, high-performance, and extensible WebAssembly runtime"
  homepage "https://WasmEdge.org/"
  url "https://github.com/WasmEdge/WasmEdge/releases/download/0.18.1/WasmEdge-0.18.1-src.tar.gz"
  sha256 "589031c828628fbae8576e9d6ef497ac9888bca964dacacaa79ad9c82f9538bc"
  license "Apache-2.0"
  head "https://github.com/WasmEdge/WasmEdge.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4dcf520433551e0c49e882da26ff2d8f0c0197862e28f01e3c7613d65b0eb4a7"
    sha256 cellar: :any, arm64_tahoe:       "6ed658695e864cf2ca874c2e08f3130c7193c2f38a921595060f404d5b142962"
    sha256 cellar: :any, arm64_sequoia:     "7760b67945473079962c1e35d305360e4797d3fd5dd2ccfe8cc4a7c12adce26e"
    sha256 cellar: :any, arm64_linux:       "ab078226432d57bfbbc116ed79534dace8daef2bbc412a4c45cb8dc9bd83236b"
    sha256 cellar: :any, x86_64_linux:      "ac67af200dda09762b4e099a568409581e57246e2e615c75d327618e97b7f158"
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
