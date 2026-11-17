class WasmMicroRuntime < Formula
  desc "WebAssembly Micro Runtime (WAMR)"
  homepage "https://github.com/wasm-micro-runtime/wasm-micro-runtime"
  url "https://github.com/wasm-micro-runtime/wasm-micro-runtime/archive/refs/tags/WAMR-2.4.6.tar.gz"
  sha256 "6a8de3f74671a72698b4bd61a96c1ce8966db077b2adad7b720757cfd9caff62"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/wasm-micro-runtime/wasm-micro-runtime.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "061c8bbfeef2fb74276f11f5a16fd3e3a393e64e270ec75c7d8df84f85b67b6a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "868ae97be1441e76511383f63b9676e039119993966ced1b09ee6b36e0894b46"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "90d8de07b469d3b8141011c79a8c1e0cc7a78914a9be15c570bdded91177fb60"
    sha256 cellar: :any,                 arm64_linux:       "802b41cb6e3f5057925868740571ac166bfbebd5c66687f294cb1c19ed05bb2c"
    sha256 cellar: :any,                 x86_64_linux:      "188d238a6e51a3e883c071f573803cf513ac0da22c2718dbc7280f080e92cf15"
  end

  depends_on "cmake" => :build

  resource "homebrew-fib_wasm", :test do
    url "https://github.com/wasm3/wasm3/raw/main/test/lang/fib.c.wasm"
    sha256 "e6fafc5913921693101307569fc1159d4355998249ca8d42d540015433d25664"
  end

  allow_network_access! :test

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
    resource("homebrew-fib_wasm").stage testpath

    output = shell_output("#{bin}/iwasm -f fib #{testpath}/fib.c.wasm 2>&1", 1)
    assert_match "Exception: invalid input argument count", output

    assert_match version.to_s, shell_output("#{bin}/iwasm --version")
  end
end
