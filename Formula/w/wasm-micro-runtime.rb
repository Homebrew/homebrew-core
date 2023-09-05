class WasmMicroRuntime < Formula
  desc "WebAssembly Micro Runtime (WAMR)"
  homepage "https://github.com/bytecodealliance/wasm-micro-runtime"
  url "https://github.com/bytecodealliance/wasm-micro-runtime/archive/refs/tags/WAMR-1.2.3.tar.gz"
  sha256 "5c1b8a72bbc1943aa6bda7cfbabb909a89bf3a4a2115ef8f8821315a5594d2e2"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-micro-runtime.git", branch: "main"

  livecheck do
    url :stable
    regex(/^WAMR[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4587fad7622d938be7daf2981bc1122f2bbc58712805e715869c2ef0c6f6af90"
    sha256 cellar: :any,                 arm64_monterey: "ea4a7e600529e8b9eff9ae75d63cb6173a7367d7edc2dcabae988d1939cae3c5"
    sha256 cellar: :any,                 arm64_big_sur:  "c2f0931318437df0f323b11e849e1f7c5068927c1a19980abaf7fa732c836612"
    sha256 cellar: :any,                 ventura:        "b3459a58b87fda1d8f3443252d1d643f794d4dee7e36be678f04669e03135327"
    sha256 cellar: :any,                 monterey:       "4d2be4bdc605ac92a629e5f1a01af4c6f1169297d30a5f7eae6c8204d23a02a7"
    sha256 cellar: :any,                 big_sur:        "3670878e30af5a164743dcc4b9397a6a36b0b53654e0000ae3933af3753cc9b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9adfdede849d11cdd909c9dd5793345550362af778c4831e2233e8e99a80638"
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
      -DCMAKE_STRIP=0
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
