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
    sha256 cellar: :any,                 arm64_monterey: "c0a38b9109ed9cfcc6901184052eb0811be19df85544ff94ff717a0274d8f1b8"
    sha256 cellar: :any,                 arm64_big_sur:  "1ed6f1071d65b77470021148d12125a262f0726681c41129eb90c9d9004bf324"
    sha256 cellar: :any,                 monterey:       "41c55c28ada9093a6c209ead50434ef9a24f9c36dde0b022c81912f994bc3f3c"
    sha256 cellar: :any,                 big_sur:        "331144af23c53902d36da43c7ec3e5413972c5fe597cb27d06d943f79b3c3afe"
    sha256 cellar: :any,                 catalina:       "04cbf45e45f900656f6268ff7a9a8f4a17aa9ac13175c29397bbbbc8972267f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "364da77f31320195c2639c54c0a62e8a63758638ba2977b941d95d589681e223"
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
