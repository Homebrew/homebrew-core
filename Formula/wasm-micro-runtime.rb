class WasmMicroRuntime < Formula
  desc "WebAssembly Micro Runtime (WAMR)"
  homepage "https://github.com/bytecodealliance/wasm-micro-runtime"
  url "https://github.com/bytecodealliance/wasm-micro-runtime/archive/refs/tags/WAMR-1.2.0.tar.gz"
  sha256 "3d5fe07414af3ef27bfdd0f8fc78a214ae4f602479c1dd4e8a0ee4400ddfb1d6"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-micro-runtime.git", branch: "main"

  livecheck do
    url :stable
    regex(/^WAMR[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b6b4ebd54943c1d7ddebadf23a08c65e6baa5c548c52bc6683b9e6d98096084a"
    sha256 cellar: :any,                 arm64_monterey: "3c7708981cb7a8620405cf91691c52401024201378419c7c2eec1f52c23fc8b2"
    sha256 cellar: :any,                 arm64_big_sur:  "d58f7a78701696b263e8d6a96d9c83542351b5f3332d4e7a034e4f7df874e73e"
    sha256 cellar: :any,                 ventura:        "516d902ca10fe5e2e5921de94fa4b4f8b787ffef491c52865405141b0ede0394"
    sha256 cellar: :any,                 monterey:       "2c03d6dcf302f74f94738670765973e66652a024f23fc9f1a5fd3c7fbee5eb78"
    sha256 cellar: :any,                 big_sur:        "75a1d108bcc7d686cdd3308569e2cbaf55a7a98d1a3c1218c4813c14406b2b94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28d42609175ac5a44d5eb65fc4adfab34b8986e35bb867e5e2013f3a1cd64734"
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

    output = shell_output("#{bin}/iwasm -f fib #{testpath}/fib.c.wasm 2>&1", 1)
    assert_match "Exception: invalid input argument count", output

    assert_match version.to_s, shell_output("#{bin}/iwasm --version")
  end
end
