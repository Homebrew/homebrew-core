class WasmMicroRuntime < Formula
  desc "WebAssembly Micro Runtime (WAMR)"
  homepage "https://github.com/bytecodealliance/wasm-micro-runtime"
  url "https://github.com/bytecodealliance/wasm-micro-runtime/archive/refs/tags/WAMR-2.4.3.tar.gz"
  sha256 "4ac27e697a3e64959756624d68ec18ce5fc54a2d3f31f1b3f702be6fcd48a7d8"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "813abc6b66e97f8b07b4513831a6f2ce0d649d9cafb2a34bf6b68f1eb0117a42"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f24a396d0a48d07d77f7afcc570b8da6ab9a3b69baaec5efe0ea929b0cdb061"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20a4dca96df6eeff3a08822169839c9b62043b4a7216236424cdaa8dbfe30d45"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a30eb9519310b933486e2b03f0f5733eca3d865061e51e522d5fc44c60f32f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd0735a1ef01e09504202bd529143fc37945512de0a87a736bf90dc17769952a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10d759a5ac9d54f7b5975357e647aad6f04967a0e6260b077bb12c9c0e0146ca"
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
