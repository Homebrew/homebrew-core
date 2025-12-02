class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/v1.242.0.tar.gz"
  sha256 "dacd8b2bf1f620f2a370ac53646d02df7b6a704f1607030c98d59dc31d9346c3"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f26899d162de7bff7ab9b8b804a3ca91c4335fdc476ecff35aa6d4a35afcd3d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f24938866c656aef7cd9c712121b99bd808d4b4a7395cb95912600603c32e4f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f312548b84c54fc9074cfc523a70d247ded94597f9bfa661366fe1fb1876652f"
    sha256 cellar: :any_skip_relocation, sonoma:        "d37847c27bc036d8de590a2cf09a05efab65b09f898e6f685ac5e4f2d02f9476"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8096de595da61dd994a0713272646c1683ecfac766b6de78746cefaf6b6f38ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee443259ff1e136cb4c702e5ddfb2c12dac5e73d15234bbd592abded9e9e030a"
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
