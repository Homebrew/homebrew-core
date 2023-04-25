class WasmMicroRuntime < Formula
  desc "WebAssembly Micro Runtime (WAMR)"
  homepage "https://github.com/bytecodealliance/wasm-micro-runtime"
  url "https://github.com/bytecodealliance/wasm-micro-runtime/archive/refs/tags/WAMR-1.2.1.tar.gz"
  sha256 "0bc1af64dd71c712334d37217dd150a42786a565485c20376aafab09c2bd727a"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-micro-runtime.git", branch: "main"

  livecheck do
    url :stable
    regex(/^WAMR[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0c432f9e3be7edb7e2ce4c9f2f7daa6dec9c1b1dba2feefcb623de2ae8a11059"
    sha256 cellar: :any,                 arm64_monterey: "a31f2da6e90ab8f2d4bf29168597d2b3cd3eafbea5214fa05ebbc0808d07afe3"
    sha256 cellar: :any,                 arm64_big_sur:  "a1935a2ad59f6db9ca5ce3c3f5fd3d2a2bef42c436cc8744229e826b853abe46"
    sha256 cellar: :any,                 ventura:        "5df3978476862d76878b7026d5fc73787ddd3fa1305d1a5eecfe183a5eb447f3"
    sha256 cellar: :any,                 monterey:       "f7a24a2f9c8755b1676fcee09dc55951393108724da56176a01799bba362c012"
    sha256 cellar: :any,                 big_sur:        "d02c62657cc9c7cb2e91069b60181f27aee0495e70364d967a2df9d51efb1d1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95555291689625bbfdb5f802849b8feb92445b74d7f535eec2b5d308f84a93d2"
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
