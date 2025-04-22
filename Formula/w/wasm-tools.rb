class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/v1.229.0.tar.gz"
  sha256 "ff3769834160b5bf1733daeeae14e6d74df85edcf49f300601927ef574790f9b"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57912571704884ec396be8f118c2639584d23dbcaf008472d173dfe6bc6fb3f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8f2a1216bd93003937c3a5ccc7bfc6d0e9b2090c1bc2bd3ece0619650c7e706"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ac60ee999b94c12bd95a3962b0cbc5f4e95b9df297133f116a69c1809563c792"
    sha256 cellar: :any_skip_relocation, sonoma:        "246763b514f2505b4cbe724ea54576ed329bf2e33da1d8a1365e69ab7e75a466"
    sha256 cellar: :any_skip_relocation, ventura:       "06580d07410202443467362bb7a13a5bb2e0aec4efdef6e403952119857a2d1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "68560c1bcae901060a9bd70e0ef1b7710bed134733e9e2582499e90f0ae57e81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91c45ae7c022d460fb72df32eb095b675f4144c8f7e6bee4cab6a40daf3af548"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    wasm = ["0061736d0100000001070160027f7f017f030201000707010373756d00000a09010700200020016a0b"].pack("H*")
    (testpath/"sum.wasm").write(wasm)
    system bin/"wasm-tools", "validate", testpath/"sum.wasm"

    expected = <<~EOS
      (module
        (type (;0;) (func (param i32 i32) (result i32)))
        (export "sum" (func 0))
        (func (;0;) (type 0) (param i32 i32) (result i32)
          local.get 0
          local.get 1
          i32.add
        )
      )
    EOS
    assert_equal expected, shell_output("#{bin}/wasm-tools print #{testpath}/sum.wasm")
  end
end
