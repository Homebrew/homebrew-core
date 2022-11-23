class Wasmer < Formula
  desc "🚀 The Universal WebAssembly Runtime"
  homepage "https://wasmer.io"
  url "https://github.com/wasmerio/wasmer/archive/refs/tags/v3.0.1.tar.gz"
  sha256 "a04a8b32890523e39b6fa3df170248db437a3067382847b8a2e5626bc6425fac"
  license "MIT"
  head "https://github.com/wasmerio/wasmer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "86f4d27b5317f658876b63a6d1d3a17a4fb712d1b1c74cbcbcb1ee4c333fab17"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68aebd6fca9f05295bca9a82a2ce35f237c3d3e192c6b2169241f76237066940"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "539384005b86c9e3628df5ce6a66961fb5cabc591ebf31aeb5f07b1d58838c73"
    sha256 cellar: :any_skip_relocation, monterey:       "afd11d592daa3baafbcf8e65087c114da0dbcdc145fd0661c8e0f40aee1038bc"
    sha256 cellar: :any_skip_relocation, big_sur:        "5e6b50aa692ca0675657336dc7ffb31a93aecce0b7c248dc1108fb8c70004779"
    sha256 cellar: :any_skip_relocation, catalina:       "b0041308bdee09c379e9ca1d363b6896c99f71d8da8fdde4f644f1b48e87e523"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8526a0a6684418190333249f7b99e7190185c6959f374b1c8a27cc95526971be"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "wabt" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libxkbcommon"
  end

  def install
    system "cargo", "install", "--features", "cranelift", *std_cargo_args(path: "lib/cli")
  end

  test do
    wasm = ["0061736d0100000001070160027f7f017f030201000707010373756d00000a09010700200020016a0b"].pack("H*")
    (testpath/"sum.wasm").write(wasm)
    assert_equal "3\n",
      shell_output("#{bin}/wasmer run #{testpath/"sum.wasm"} --invoke sum 1 2")
  end
end
