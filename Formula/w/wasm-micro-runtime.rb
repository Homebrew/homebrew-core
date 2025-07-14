class WasmMicroRuntime < Formula
  desc "WebAssembly Micro Runtime (WAMR)"
  homepage "https://github.com/bytecodealliance/wasm-micro-runtime"
  url "https://github.com/bytecodealliance/wasm-micro-runtime/archive/refs/tags/WAMR-2.4.0.tar.gz"
  sha256 "5b4700834689721290664ea260f891a8a494d7634cb4a55eea88cfd6c0b737d0"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f2f1777d817ba68c9b278a5e0fdc436aa2e59e7942794c690bfbd0757de5f48"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54ea7ffa49a139fea1b886d8a697a9081bdc28e9caf005ee6ffac97794287812"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cc326a7701ba2041f95869407ca67508724fa9a5b8866097c525d6e388c4c0f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "fde0fa682a21cc8034f1161c6f2f288d5a23495339fc431a5d125ae7e3320336"
    sha256 cellar: :any_skip_relocation, ventura:       "655238f41072addc52591c42e5d5cc1975635d9ba70081d73532f78b7ddde31b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d215f33717ac086c527bcb6e118907ad95426ea132b88f7b9867724d73d72171"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dab5002319d92fbea29cc0fce32f13176140479ce1aa799574a4fcec1a114bc2"
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
      -DWAMR_BUILD_SIMD=0
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
