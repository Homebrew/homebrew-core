class WasmMicroRuntime < Formula
  desc "WebAssembly Micro Runtime (WAMR)"
  homepage "https://github.com/bytecodealliance/wasm-micro-runtime"
  url "https://github.com/bytecodealliance/wasm-micro-runtime/archive/refs/tags/WAMR-2.1.2.tar.gz"
  sha256 "180b6431d63b8e8c55e6ad4b01a76b0d549f1c8205fcc4c657cb66e6f221799f"
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
    sha256 cellar: :any,                 arm64_sequoia:  "c52826cf1aff5bdc8b423e86ecfad7607c50e794560ce756ee6bb8da9b1f2ea1"
    sha256 cellar: :any,                 arm64_sonoma:   "61beb73dac2495f4b4432d200ed9ab9adaf84e58b2b8a4355776063c8afcf984"
    sha256 cellar: :any,                 arm64_ventura:  "39d8e7f7eef217b5d5d92a6c9ab42d9a80cae5b109148a05942b6e8900232861"
    sha256 cellar: :any,                 arm64_monterey: "bbcb76e43f787bc2937bbadf6b8403ba5ad00440c6ad30679ee3ba6e158566ce"
    sha256 cellar: :any,                 sonoma:         "5dd7f5e5ef4167ba177cbfca4093b63f3b1d6411641809e2d84b660fc87e3f25"
    sha256 cellar: :any,                 ventura:        "d3a4c9ae70bc138d53b98285cdb1a045efa8bb5edac471309a3c2093d9065805"
    sha256 cellar: :any,                 monterey:       "b7b124b6bdfae0539011d3085c260a4194cf7c42c72351ff6c211ef86585cd9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f17549da91bccdca481404d0da71635a7fcadb282f7ad17bf885b289f8f19072"
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
