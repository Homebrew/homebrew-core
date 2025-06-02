class WasmMicroRuntime < Formula
  desc "WebAssembly Micro Runtime (WAMR)"
  homepage "https://github.com/bytecodealliance/wasm-micro-runtime"
  url "https://github.com/bytecodealliance/wasm-micro-runtime/archive/refs/tags/WAMR-2.2.0.tar.gz"
  sha256 "93b6ba03f681e061967106046b1908631ee705312b9a6410f3baee7af7c6aac9"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-micro-runtime.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8c09d15112bc9ac42ab86ccc8baf1881ec3653a0d589dfad8a7aa41ae5f4d411"
    sha256 cellar: :any,                 arm64_sonoma:  "9b5b5ea15d69f031cd2d314a8bcf70d804c210280b330be3fb0034726cf36f75"
    sha256 cellar: :any,                 arm64_ventura: "2e6ac37ea867c542514480907f9b0710e477c67dd286c1208930444da16582f4"
    sha256 cellar: :any,                 sonoma:        "92ed7cdc11f95b3d4be42b9b2878e9c66aae6f0c537be17fcb0731ded92a7dd2"
    sha256 cellar: :any,                 ventura:       "f4ba8cddef3b9e781ead80432292f6996a9f259c68b3696d8d1b3589f7f4250e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6da5ec11f4d8ac7985ef99003c52b7e82a1c0393a4db179fc463942e7b89f01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1c67ba32fefde0efd67412efe9853e03b47fb0a8cfd845d03a795d231e130a6"
  end

  depends_on "cmake" => :build

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
    resource "homebrew-fib_wasm" do
      url "https://github.com/wasm3/wasm3/raw/main/test/lang/fib.c.wasm"
      sha256 "e6fafc5913921693101307569fc1159d4355998249ca8d42d540015433d25664"
    end

    resource("homebrew-fib_wasm").stage testpath

    output = shell_output("#{bin}/iwasm -f fib #{testpath}/fib.c.wasm 2>&1", 1)
    assert_match "Exception: invalid input argument count", output

    assert_match version.to_s, shell_output("#{bin}/iwasm --version")
  end
end
