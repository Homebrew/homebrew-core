class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/v1.241.2.tar.gz"
  sha256 "740ebd8d3dd293ba1a6f94c258cde9f19ed8af43325e24682d2b58367edabc9a"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "208a0551ffd834375b15762851142ee71341293107ffda37f4781233cca97b26"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3443015f8289b4216dfd89eed6a6cf19be55c4e02169983acd4d59b5b07e2860"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "772b9d0d2c70adfc11e03a5b803cd69f1e75d340d88aa176ab5070c8dd677c65"
    sha256 cellar: :any_skip_relocation, sonoma:        "57dcec5ea14cd090e9758304b7c32fc483039bae3566840c4e5431e49ab8d9f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "524bd392b7d33ad4adf9467a68b5154f0d41124f818550b2ebc6b801e66a605a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98ad75ad180ab0e0afce5252125c63ebff89873c63cb16de8bc3d11be427e01b"
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
