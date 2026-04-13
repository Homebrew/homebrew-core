class Wasmedge < Formula
  desc "Lightweight, high-performance, and extensible WebAssembly runtime"
  homepage "https://WasmEdge.org/"
  url "https://github.com/WasmEdge/WasmEdge/releases/download/0.16.1/WasmEdge-0.16.1-src.tar.gz"
  sha256 "fc256b8be022eb0487549cc2119c57fd12ad402e4130a05263b7aa85e2df89b9"
  license "Apache-2.0"
  revision 1
  head "https://github.com/WasmEdge/WasmEdge.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b74cd16cf0d26056adf5ff7045b7fc62a22786717933f1f49d50b6cf5fd21d2a"
    sha256 cellar: :any,                 arm64_sequoia: "2051e0817c645a6dda47f6a4e7aa620b61f7035f1897bd2387657708c5c134ab"
    sha256 cellar: :any,                 arm64_sonoma:  "f6a5895f3068e70639a9ab825d3c4cc4d2c0b9c32deaccb55894827209204cd7"
    sha256 cellar: :any,                 sonoma:        "6af51419bc3294ade55e569848c81818d668df0b1a47ca39dbe8e3d8683f4fc5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f106a5e86dc8482c9844b7588157e62b222f7a27531efbb4902e57e1017f624e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bae8285dce0643fd38456fb163ecc2e1a0869e841c979d5f87d9bbf8898274cb"
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
