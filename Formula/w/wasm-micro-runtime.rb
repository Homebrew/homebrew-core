class WasmMicroRuntime < Formula
  desc "WebAssembly Micro Runtime (WAMR)"
  homepage "https://github.com/bytecodealliance/wasm-micro-runtime"
  url "https://github.com/bytecodealliance/wasm-micro-runtime/archive/refs/tags/WAMR-2.4.1.tar.gz"
  sha256 "f36650ef534f8bc138ed38385d46cfa5d053fb5696f799a9c783b62418ba726b"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c466fd168f87c8e8827c45ff594a2684c150deb74534c0c1c8aee11580a7ae89"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e29908e37224bc325795967a940219396bc4b3531577538ca6c2d7ca67431377"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dbd2ec205b620a18150fdd279196c2e06bee8e5a3c798da42794c86b287d1a3f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "18d20c76e65880203488374303f966a2670a845e578beb4dcc637e58be0f5479"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2958500c4506395d2ec662c7492faafa449729c118f296b6596e991053a5c7b"
    sha256 cellar: :any_skip_relocation, ventura:       "65b3c423facc824fcc567a537bfde2d8e7cf569a394daff37cb3589ab9df0720"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a0064daa64a46e2700be21c0e1de688b355e704811352bc987ddc38766669e0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46e1121d56bafdaebb2617b1a7c4ce5a71ac99e726debe971b3f3ded2b619543"
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
