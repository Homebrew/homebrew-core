class WasmMicroRuntime < Formula
  desc "WebAssembly Micro Runtime (WAMR)"
  homepage "https://github.com/bytecodealliance/wasm-micro-runtime"
  url "https://github.com/bytecodealliance/wasm-micro-runtime/archive/refs/tags/WAMR-2.1.1.tar.gz"
  sha256 "04daaa934ca5bd1972432dd353b9d04a046c2d956fc923b01f74fe6af6f44f4b"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-micro-runtime.git", branch: "main"

  livecheck do
    url :stable
    regex(/^WAMR[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f094c375c1cafef40a01771411339843a67a4e239e7019b61d3b7daf2ac7ac4a"
    sha256 cellar: :any,                 arm64_ventura:  "6ff0a2e7bc65448d9eb8b2898e0c1d07006aefe2abafdf01298be5a67c73a631"
    sha256 cellar: :any,                 arm64_monterey: "54b43d8e5a5cc4ea92d6b40969a8b36863bacb972fdd6e0b6c7e31f966bedc6b"
    sha256 cellar: :any,                 sonoma:         "fc43b4dbc0053ed15e13893f1f869b19956cf7febf6c75e9a6e4db0ed79614d7"
    sha256 cellar: :any,                 ventura:        "beeafeb6e7de7c2f0e803fcf5a07107362b06430905bcbc556823024eba9316a"
    sha256 cellar: :any,                 monterey:       "f4a325bf790976f544b901aca4d211e7148c479b7b7cd7b7d2096449697e14e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9240900df3213c8ebeb0497212a4cca6048dd4f8dfd87003aeb33300a8ec4000"
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
