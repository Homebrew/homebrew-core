class WasmMicroRuntime < Formula
  desc "WebAssembly Micro Runtime (WAMR)"
  homepage "https://github.com/bytecodealliance/wasm-micro-runtime"
  url "https://github.com/bytecodealliance/wasm-micro-runtime/archive/refs/tags/WAMR-1.2.3.tar.gz"
  sha256 "85057f788630dc1b8c371f5443cc192627175003a8ea63c491beaff29a338346"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-micro-runtime.git", branch: "main"

  livecheck do
    url :stable
    regex(/^WAMR[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "eb7548ab97f95d4a6d4d0f43c4c7fb261374e9134d9b27e92084abbffb8ae273"
    sha256 cellar: :any,                 arm64_ventura:  "3975c84c868b6eec78e1b075da8bad7a235616c01d83c4e0ab808990f989f01d"
    sha256 cellar: :any,                 arm64_monterey: "1747204fb53f6c96551610a2b8226a8b2277656a096b03c60d81975c74e66ace"
    sha256 cellar: :any,                 arm64_big_sur:  "c8e7c910470047d01fd23a25c4172b328cb6a4566c4128a76e9b6df8f0d61a49"
    sha256 cellar: :any,                 sonoma:         "adbbc9412f0c212865d6ceaffe5f84b32293db00aec063a09baaeeb23d5d6bc7"
    sha256 cellar: :any,                 ventura:        "85a5dfdc98032dd9d044330cb1fe46d83cae68acfd21dbe44895b5a3c245e879"
    sha256 cellar: :any,                 monterey:       "cd963081401046b3282637eb84cd9ed6aa1e6f9e0a777504de2457c6a37352a4"
    sha256 cellar: :any,                 big_sur:        "e263f0708d0534cc0004964292889c610d9cc9f58a4502475f10b581ceddb646"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "733cf0beac6d19b7bde46a6ec2674d3d42e808bcbce73780b4d1809886621470"
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
