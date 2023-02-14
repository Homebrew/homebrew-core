class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/wasm-tools-1.0.24.tar.gz"
  sha256 "9ed44546483fcffbc7b4fd05e45bf4f7176a4c86b274b1e16f9e4b68a255ac8d"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^wasm-tools[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d53e7554796b2f8923080c13d8376ac981949125c18f4504734fe63b0802fc94"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8eedef1d5b8d3623cc5a290831b20bdbd18523c3c19f2d6ceb37f7ebae526a45"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3644c941ca5548a5e5b73d3ce768bd7cb4306bf8857981e39f2e26c987101f00"
    sha256 cellar: :any_skip_relocation, ventura:        "66fe33e553999a86ded5eeb03f8ac43d57d8388862dceca951a8308d9eba0412"
    sha256 cellar: :any_skip_relocation, monterey:       "a01429cbfd874b4e68c35220be43e129f0ec49de4f1dc6329f388a90d7a75080"
    sha256 cellar: :any_skip_relocation, big_sur:        "1c47316c4cb9b853440fb590166e8b83c250d4df9e8a1419ca379970c66a294a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93e39629a85d2f046e4abc3e55a38b51e95e8f99817628214f115151c87225c1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    wasm = ["0061736d0100000001070160027f7f017f030201000707010373756d00000a09010700200020016a0b"].pack("H*")
    (testpath/"sum.wasm").write(wasm)
    system bin/"wasm-tools", "validate", testpath/"sum.wasm"

    expected = <<~EOS.strip
      (module
        (type (;0;) (func (param i32 i32) (result i32)))
        (func (;0;) (type 0) (param i32 i32) (result i32)
          local.get 0
          local.get 1
          i32.add
        )
        (export "sum" (func 0))
      )
    EOS
    assert_equal expected, shell_output("#{bin}/wasm-tools print #{testpath}/sum.wasm")
  end
end
