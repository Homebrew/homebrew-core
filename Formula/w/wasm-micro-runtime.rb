class WasmMicroRuntime < Formula
  desc "WebAssembly Micro Runtime (WAMR)"
  homepage "https://github.com/bytecodealliance/wasm-micro-runtime"
  url "https://github.com/bytecodealliance/wasm-micro-runtime/archive/refs/tags/WAMR-2.4.4.tar.gz"
  sha256 "03ad51037f06235577b765ee042a462326d8919300107af4546719c35525b298"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb1fb11460b0ba366b42a53826db2f0dc32c572650a5658f741696f76a0af5aa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ca95524c2802e0fa4abc778ae0a597688ff236d4a250c23fe60325899e37341"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "887b91d48d7b797b7b8fed98196dfa5c3bed74193195143df8df7c5f8255e0d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f916c8ea659a2ea61fa5e5058475823a22002ee0b282cf45c49861428b95e88"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c465af087d23419ecdf9895fe47703c6dcff7a9707c923ee6d8330d9f135ee3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50a35bc9d1fd6da9029443fd5120883f0deee39044e87bbb755f109c5197c374"
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
