class WasmMicroRuntime < Formula
  desc "WebAssembly Micro Runtime (WAMR)"
  homepage "https://github.com/bytecodealliance/wasm-micro-runtime"
  url "https://github.com/bytecodealliance/wasm-micro-runtime/archive/refs/tags/WAMR-1.1.1.tar.gz"
  sha256 "3bf621401e6f97f81c357ad019d17bdab8f3478b9b3adf1cfe8a4f243aef1769"
  license "Apache-2.0"
  head "https://github.com/bytecodealliance/wasm-micro-runtime.git", branch: "main"

  livecheck do
    url :stable
    regex(/^WAMR[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0cd1b0d3cfe6dd8da18bfb7a358f0ec9d23f6d1c54781c0b24137fa1010f2742"
    sha256 cellar: :any,                 arm64_big_sur:  "eb3d32b2007d62a3896f052b7c23a66da2f92810438efb5115251223ce316aad"
    sha256 cellar: :any,                 monterey:       "94f38ee756250d426477c6c2c7312e635026ed92537ee568c53d1c890ef5583c"
    sha256 cellar: :any,                 big_sur:        "973544abf6190a1958b788c5f33e57768f97cb0210e455be622dc0cc1633bf1c"
    sha256 cellar: :any,                 catalina:       "4cc9254bd0f79a6b219cc588ddd2ae4a855a21b198147e99d5fe3ea878bd8851"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "953427a498dda4e99330869b623dd71697d96b6648127740ab3682abd09a8004"
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
