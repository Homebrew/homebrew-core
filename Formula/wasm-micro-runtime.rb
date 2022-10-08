class WasmMicroRuntime < Formula
  desc "WebAssembly Micro Runtime (WAMR)"
  homepage "https://github.com/bytecodealliance/wasm-micro-runtime"
  url "https://github.com/bytecodealliance/wasm-micro-runtime/archive/refs/tags/WAMR-1.1.0.tar.gz"
  sha256 "608933db9273de222dc183cee3d32f084f91b90205c420d000a3276c522f9263"
  license "Apache-2.0"
  head "https://github.com/bytecodealliance/wasm-micro-runtime.git", branch: "main"

  livecheck do
    url :stable
    regex(/^WAMR[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "76b7d0f9fe1be60e1b33091acece2afec12545561663cba4abc75f76a89d10da"
    sha256 cellar: :any,                 arm64_big_sur:  "607bae21939f03e76ad9b6bdaeea3c2a7aec478a6a859d92e596f72c21837e34"
    sha256 cellar: :any,                 monterey:       "9bffd5d15505686eabcaf7302f48023d0dea2a3851d00b2c780f12d90a98ad00"
    sha256 cellar: :any,                 big_sur:        "862cbde690d53aa4acff7a1bceace24448a6d397cfc7b9119883741ded468c60"
    sha256 cellar: :any,                 catalina:       "378727ff0ef6a0ce2ed32edd864ed2fbe0d66fd25061254e42026d60e3bba170"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9510e8a281f424e9463b96ea97ead563b4a188bd75ffc22a2e1c6c3677d10b01"
  end

  depends_on "cmake" => :build

  resource "homebrew-fib_wasm" do
    url "https://github.com/wasm3/wasm3/raw/main/test/lang/fib.c.wasm"
    sha256 "e6fafc5913921693101307569fc1159d4355998249ca8d42d540015433d25664"
  end

  def install
    # Prevent CMake from downloading and building things on its own.
    buildpath.glob("**/build_llvm*").map(&:unlink)
    buildpath.glob("**/libc_uvwasi.cmake").map(&:unlink)
    cmake_args = %w[
      -DWAMR_BUILD_MULTI_MODULE=1
      -DWAMR_BUILD_DUMP_CALL_STACK=1
      -DWAMR_BUILD_JIT=0
      -DWAMR_BUILD_LIBC_UVWASI=0
    ]
    cmake_source = buildpath/"product-mini/platforms"/OS.kernel_name.downcase

    # First build the CLI which has its own CMake build configuration
    system "cmake", "-S", cmake_source, "-B", "platform_build", *cmake_args, *std_cmake_args
    system "cmake", "--build", "platform_build"
    system "cmake", "--install", "platform_build"

    # As a second step build and install the shared library and the C headers
    system "cmake", "-S", ".", "-B", "build", *cmake_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource("homebrew-fib_wasm").stage testpath
    system "#{bin}/iwasm", "-f", "fib", "#{testpath}/fib.c.wasm"
  end
end
