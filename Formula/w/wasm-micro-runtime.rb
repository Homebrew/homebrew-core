class WasmMicroRuntime < Formula
  desc "WebAssembly Micro Runtime (WAMR)"
  homepage "https://github.com/bytecodealliance/wasm-micro-runtime"
  url "https://github.com/bytecodealliance/wasm-micro-runtime/archive/refs/tags/WAMR-2.0.0.tar.gz"
  sha256 "7663a34b61d6d0ff90778d9be37efde92e2f28ec9baad89f7b18555f0db435ab"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-micro-runtime.git", branch: "main"

  livecheck do
    url :stable
    regex(/^WAMR[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d6cd753964daa9f3cfb8fb99602b600848b47d6e0d0670b165651be9daecab7d"
    sha256 cellar: :any,                 arm64_ventura:  "2e1abb59846f0d6f0406ff01529e8e2bf70c21dbcba089e787875a8c1a5b51ac"
    sha256 cellar: :any,                 arm64_monterey: "1c6b6851d37ef1ba30168486052e5edb7fbc91fbdffe01e63de90b13abc14282"
    sha256 cellar: :any,                 sonoma:         "39d255c15322b3fc646eb6368106e9619768e90045f6bd99c48f93894d373100"
    sha256 cellar: :any,                 ventura:        "6ffbd3c141ee708900dd23f237fcf944ef4a8e7fafb064b326fd0e5bdccfdeb0"
    sha256 cellar: :any,                 monterey:       "5be24f27edd1e8509eb383963c3c3965454dfded765a4137e9f6f935edbaa85d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c3a3f67fea3fc2e63e7e51f81aff7050330ef0b8e87660b627a31f6f7f0fbb4"
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
