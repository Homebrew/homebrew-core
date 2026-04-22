class Wasmedge < Formula
  desc "Lightweight, high-performance, and extensible WebAssembly runtime"
  homepage "https://WasmEdge.org/"
  url "https://github.com/WasmEdge/WasmEdge/releases/download/0.16.2/WasmEdge-0.16.2-src.tar.gz"
  sha256 "c8df006bb43baaba1e8d52ac7ee6c13dc2f32f7e1456341fd621b51d53ec4f4d"
  license "Apache-2.0"
  head "https://github.com/WasmEdge/WasmEdge.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "673b2858ef5c026b68016a471c1f33977414d2c80a2c97d554d3e4d887d82169"
    sha256 cellar: :any,                 arm64_sequoia: "df1685a2203911ca2b4fecd7d4f70a5795c1fa2def67cbf89f4017a98b040d64"
    sha256 cellar: :any,                 arm64_sonoma:  "07791a9b7d25dbceb92502ca4efec8ada10303e206e258faca807cd45639e98d"
    sha256 cellar: :any,                 sonoma:        "918caef6241368801ae8e33beebbd5424fbc0e423cc0626313076b9ad45f9d9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b4c1b472b5fd9bd9e2913e0d0fed3b69dc85c9c02c31488b32a3d03f0a89d14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ad145e7f6910db001a762a143102c2359497af287c3eebddca743621fe1785f"
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
