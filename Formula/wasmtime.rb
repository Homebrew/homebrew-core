class Wasmtime < Formula
  desc "Standalone JIT-style runtime for WebAssembly, using Cranelift"
  homepage "https://wasmtime.dev/"
  url "https://github.com/bytecodealliance/wasmtime.git",
      tag:      "v0.35.0",
      revision: "9137b4a50e2e883ac23049f6abf3381155620189"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasmtime.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad1885cf8724b9fe8bd31d04e2127ec046ec72ee6ef358e78d5a299a067b6318"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ce35d0a6553f4aee6590d56aba186bc00baea28f51f2659c77606edb9ba66d4f"
    sha256 cellar: :any_skip_relocation, monterey:       "86f47b4d111748cc4781d64d2f269e9bd1f3f3989f288ea09dcc75bbe57bb53d"
    sha256 cellar: :any_skip_relocation, big_sur:        "a007d9fa89b991dc63b6bc4bcff695530d59d365bc9b3321fd8d4954f58c848e"
    sha256 cellar: :any_skip_relocation, catalina:       "13b4bca12d950da463d1c9b2d1135cd344a065c57dcd4861f59277725088032d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a211270ea9d57becf8dfe674a199df4c9406475b294da6f1de87dc6106a352e1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    wasm = ["0061736d0100000001070160027f7f017f030201000707010373756d00000a09010700200020016a0b"].pack("H*")
    (testpath/"sum.wasm").write(wasm)
    assert_equal "3\n",
      shell_output("#{bin}/wasmtime #{testpath/"sum.wasm"} --invoke sum 1 2")
  end
end
