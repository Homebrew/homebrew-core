class Wasmedge < Formula
  desc "Lightweight, high-performance, and extensible WebAssembly runtime"
  homepage "https://WasmEdge.org/"
  url "https://github.com/WasmEdge/WasmEdge/releases/download/0.17.1/WasmEdge-0.17.1-src.tar.gz"
  sha256 "c8881a8c43407fc424ccd8586594a79068305b31c76aad0025efea9339be18e0"
  license "Apache-2.0"
  revision 1
  head "https://github.com/WasmEdge/WasmEdge.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b38d61d2366988ee2e213a1683b197109a7e50c560c1ddfb6bb82c56f185f79e"
    sha256 cellar: :any, arm64_tahoe:       "08a15d84119eb87825abb2cd5ccbed0765fd766444bfda266066a5d66fc00e04"
    sha256 cellar: :any, arm64_sequoia:     "4805b96d3cc962277a7f87f9bb8c22009df4a2eedbd8869a16dd6f2d9229cab9"
    sha256 cellar: :any, arm64_sonoma:      "066d710be5450fb820f186aff4c6b893abf8e0bdb67d0ae5232af900f6943625"
    sha256 cellar: :any, sonoma:            "8cbace2766fe8682361d1486449e27d21ddb42e6f5aea441ec338c011526323c"
    sha256 cellar: :any, arm64_linux:       "e62328ea1a1cb84202a5125a618c00f28489c26c4ba64543d20e2c990d4be538"
    sha256 cellar: :any, x86_64_linux:      "e68050c525b9db68df52cc9deb393f1f8e47c785ec4b727471f4e920b104dbce"
  end

  depends_on "cmake" => :build
  depends_on "fmt"
  depends_on "lld"
  depends_on "llvm"
  depends_on "spdlog"

  # fmt 12.2 dropped operator~ on uint128_fallback; upstream fix not in 0.17.1.
  patch do
    url "https://github.com/WasmEdge/WasmEdge/commit/41a01b6b4f40defbac0dd551663c542cdcf9ae76.patch?full_index=1"
    sha256 "55657c3a628a406b655ba224019f0121f2489140dca128c3f8c623c019de84b1"
    type :backport
    resolves "https://github.com/WasmEdge/WasmEdge/pull/4936"
  end

  def install
    # Use CMAKE_BUILD_WITH_INSTALL_RPATH to keep versioned LLVM in RPATH on Linux
    args = ["-DCMAKE_BUILD_WITH_INSTALL_RPATH=ON"] if OS.linux?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # sum.wasm was taken from wasmer.rb
    wasm = ["0061736d0100000001070160027f7f017f030201000707010373756d00000a09010700200020016a0b"].pack("H*")
    (testpath/"sum.wasm").write(wasm)
    assert_equal "3\n",
      shell_output("#{bin}/wasmedge --reactor #{testpath/"sum.wasm"} sum 1 2")
  end
end
