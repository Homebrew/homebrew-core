class WasmMicroRuntime < Formula
  desc "WebAssembly Micro Runtime (WAMR)"
  homepage "https://github.com/bytecodealliance/wasm-micro-runtime"
  url "https://github.com/bytecodealliance/wasm-micro-runtime/archive/refs/tags/WAMR-1.3.2.tar.gz"
  sha256 "58961ba387ed66ace2dd903597f1670a42b8154a409757ae6f06f43fe867a98c"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-micro-runtime.git", branch: "main"

  livecheck do
    url :stable
    regex(/^WAMR[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0defcf0bd94fae2d08fa4a55873bc3438c9c08395bb8768c489797149e3ad43e"
    sha256 cellar: :any,                 arm64_ventura:  "cad8653b3128ba41e476333767d864911e7e25fe8977141945fbbaeb3d244c43"
    sha256 cellar: :any,                 arm64_monterey: "f70382e866a788da1f03546d811ca150f592477e50ddfff17120a1dfca7634f4"
    sha256 cellar: :any,                 sonoma:         "a12a70315267fdc1b9480266b8f125b43eacc579fc8c9674b5c2faa6dd37d1ad"
    sha256 cellar: :any,                 ventura:        "0a732498686ddbc841c4d3502593ea06572ca3abe175e4a18c72a0255abaef09"
    sha256 cellar: :any,                 monterey:       "75fb4257f43dd46490f5f6477bc454256ff03c1243400ae542a7913bd1ba610b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1b14188ce0eee8259ce5574c55a207adfd0c981dcd1546e79d98a2b93ce499f"
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
