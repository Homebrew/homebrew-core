class WasmMicroRuntime < Formula
  desc "WebAssembly Micro Runtime (WAMR)"
  homepage "https://github.com/bytecodealliance/wasm-micro-runtime"
  url "https://github.com/bytecodealliance/wasm-micro-runtime/archive/refs/tags/WAMR-1.3.0.tar.gz"
  sha256 "a224090e6b1c29b272d5393deeba6db67348a921f08f7a00864606330cf46187"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-micro-runtime.git", branch: "main"

  livecheck do
    url :stable
    regex(/^WAMR[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a8b2165fb209001e71aedb2c742f3d35fe55c7164b947100991d360ff6dc778b"
    sha256 cellar: :any,                 arm64_ventura:  "c0506009278c37458ddef80e95d416a16935a8f3adc2086f683d7095fd300041"
    sha256 cellar: :any,                 arm64_monterey: "dddc9fcef4cc1fed880e4872223fb81cc21ddbf2a909461b7174f7d6e9d9b16e"
    sha256 cellar: :any,                 sonoma:         "5248b2aba82e132604118d1c5b0de13724ef276d65aac6ecc55efebf2956018d"
    sha256 cellar: :any,                 ventura:        "157fed389e5c6f8fb4c124a85ed882375ad41ccfed6ebb671ed5b3722ce6eef0"
    sha256 cellar: :any,                 monterey:       "2cdde73802a41d9e6a28c6c5b59a6f4129d573cf9d00f3bcbbc2efed22aba627"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ec4e522017b62feca6eab61bc7c353fd6e84e9ad322e1d72eebc3dcd4550e8e"
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
