class WasmMicroRuntime < Formula
  desc "WebAssembly Micro Runtime (WAMR)"
  homepage "https://github.com/bytecodealliance/wasm-micro-runtime"
  url "https://github.com/bytecodealliance/wasm-micro-runtime/archive/refs/tags/WAMR-2.1.0.tar.gz"
  sha256 "0513b92912e08d0ace99727aaac9cd3e1a2dfdee34642096c8284b117398cfc0"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-micro-runtime.git", branch: "main"

  livecheck do
    url :stable
    regex(/^WAMR[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "676b8eaa22ac1c954710148d8aef5d45e8aaef091c535c4d3faa414923b1f4f3"
    sha256 cellar: :any,                 arm64_ventura:  "5e21e2e7af3217f65e47314c8ad7d2f3bc93e91516069b5e10dcd52a59b67529"
    sha256 cellar: :any,                 arm64_monterey: "666c311ec03413af9c38974358eeba15fa01e9f2681b7881ce4dec6a97b917f9"
    sha256 cellar: :any,                 sonoma:         "1c90a410e08c9707e8c30d768c071c733f325129229eb8b014707b8a84613275"
    sha256 cellar: :any,                 ventura:        "45b138b7403cf8037b72a6d0d94ce752b91a12dc31e81460078559902dd6ce4b"
    sha256 cellar: :any,                 monterey:       "39cec4ecf3d549e7ff1de2e401e42423220d851a6d6facc43af56b75a7a161c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa33a4503a613478dfe1b09637396e727c26382fb5f0439e8575475f22b752b2"
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
