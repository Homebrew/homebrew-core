class WasmMicroRuntime < Formula
  desc "WebAssembly Micro Runtime (WAMR)"
  homepage "https://github.com/bytecodealliance/wasm-micro-runtime"
  url "https://github.com/bytecodealliance/wasm-micro-runtime/archive/refs/tags/WAMR-1.2.2.tar.gz"
  sha256 "d328fc1e19c54cfdb4248b861de54b62977b9b85c0a40eaaeb9cd9b628c0c788"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-micro-runtime.git", branch: "main"

  livecheck do
    url :stable
    regex(/^WAMR[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "181341349a9b3026597d51c624a2b255f1d0440644df2c1b13205bee1f318e81"
    sha256 cellar: :any,                 arm64_monterey: "9433f36989f142176de102697b05ee27873a9b66043d11fc6413349ede4dbc42"
    sha256 cellar: :any,                 arm64_big_sur:  "8ba285831eb9b9516577e2f7b7dd16c40959e970fef86e9482b33e5be4c5fcee"
    sha256 cellar: :any,                 ventura:        "dfb24a6ab8fbac094c65794de5f4541a40e2dbf1da6e07f8285d863ffeafb923"
    sha256 cellar: :any,                 monterey:       "09b96fbdc7299407d93ab7e4951a2dd20d1f5fd46c3899a38d68128953922aaf"
    sha256 cellar: :any,                 big_sur:        "3a4043d8dc69191efdcc444e34b0f06750ab30bda69f1bcacc6ca7cc3540dbd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55d7b4ff3e905dbb087f19fef36b689374d31bc5b10d58efd57b1c609b3c2759"
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
