class Wasmedge < Formula
  desc "Lightweight, high-performance, and extensible WebAssembly runtime"
  homepage "https://WasmEdge.org/"
  url "https://github.com/WasmEdge/WasmEdge/releases/download/0.16.3/WasmEdge-0.16.3-src.tar.gz"
  sha256 "a9dace1c7552f1ea0b3ce1e16f834fe12bbff1651639fbacc361c25bcdd4204a"
  license "Apache-2.0"
  head "https://github.com/WasmEdge/WasmEdge.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "01701d4ba5f9b273f1f720cbbf6063cb07782e745bc4c8611458a91fb4af320f"
    sha256 cellar: :any,                 arm64_sequoia: "609b4785a75483092ac6337d2cc017257b06df4aada30dcd1d281d4056ea3241"
    sha256 cellar: :any,                 arm64_sonoma:  "6a48d4e8803dd31e315ee09001dd094b247b75ed31e4e62aa19e9c4b4531b540"
    sha256 cellar: :any,                 sonoma:        "5f066120ad33b280d3a26e90bbebe240f728bbc199aad87a49295cab689eb47a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "43809c998cdc64a5eaabd8bc3d8d6f3d3715a443f95999c5e4c4bab98bef9997"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78d114a446a1041a1793592a6c4bd60a8fba7a208f4ad2145da79169a75bf293"
  end

  depends_on "cmake" => :build
  depends_on "fmt"
  depends_on "lld"
  depends_on "llvm"
  depends_on "spdlog"

  # Fix error: 'is_class' cannot be specialized on macOS 26
  # PR ref: https://github.com/WasmEdge/WasmEdge/pull/4796
  patch do
    url "https://github.com/WasmEdge/WasmEdge/commit/aa0d621c0241af22c34400e5a617f0e0e83c504b.patch?full_index=1"
    sha256 "1d76615c23e13324c62f1bea009f41c3f2257b261cf3f325556480d414f67a90"
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
