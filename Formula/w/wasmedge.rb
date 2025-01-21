class Wasmedge < Formula
  desc "Lightweight, high-performance, and extensible WebAssembly runtime"
  homepage "https://WasmEdge.org/"
  url "https://github.com/WasmEdge/WasmEdge/releases/download/0.14.1/WasmEdge-0.14.1-src.tar.gz"
  sha256 "e5a944975fb949ecda73d6fe80a86507deb2d0a221b2274338807b63758350b4"
  license "Apache-2.0"
  revision 1
  head "https://github.com/WasmEdge/WasmEdge.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f6ae6e711e190c45a027eccd05ca4415c55888ea94a00439fbe7bbd0c6a941c8"
    sha256 cellar: :any,                 arm64_sonoma:  "f08075f0ed49f38c7d55bf912a1b313b1d63578c79d5893712b49a985a8f3003"
    sha256 cellar: :any,                 arm64_ventura: "c1d79e101c67d214b8801143665250b442159a5fdcc117843b9fb3151678877d"
    sha256 cellar: :any,                 sonoma:        "ba7e25a126a64a5a9c039e2a814a90f1aa7ae93384d2da5aed5a6eb3b9cf2b1a"
    sha256 cellar: :any,                 ventura:       "acc7cb9c933d4834accf98d4c6bd8c3a6ab37a161127b4b0e61d1d1e7a5dc690"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e93dc0a0ce969f97bd6bb5c6066d097c3bd7cd322de2293e309ce14defc4ac2d"
  end

  depends_on "cmake" => :build
  depends_on "fmt"
  depends_on "lld"
  depends_on "llvm"
  depends_on "spdlog"

  uses_from_macos "zlib"

  on_linux do
    depends_on "zstd"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
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
