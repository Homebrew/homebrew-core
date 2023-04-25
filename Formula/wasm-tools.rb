class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/wasm-tools-1.0.30.tar.gz"
  sha256 "92c8861dc6b101dd624cf20fcc490f31f431604c4337ab0f944b068580a590cd"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^wasm-tools[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2952c70af4f16a8b5eeb24a9f75d2da71e40d804322e5c955696b8fa468c9a93"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bfbf1ac95f3abeedcce3e9357627d1196208959a79c6195a615f121561ee9d7a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "467ef17b456dafbe375fce086baecfefcdb8c81e148888115ada79b862cdae67"
    sha256 cellar: :any_skip_relocation, ventura:        "23f8ec619c08454d3d30c82c43984e4c19a237ff0ff271b68ffebe68397f47f2"
    sha256 cellar: :any_skip_relocation, monterey:       "02eb0444dee22f244696daa77d26f24337bd13b5e9fe4ea73d904e34d6456289"
    sha256 cellar: :any_skip_relocation, big_sur:        "f4e3cc4ebac1442e90463a1214fdb26cf8cd42467b203c064a2796438ddbf9ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dcbc8320ae10e372094f7a3ce6ebefbbc758de531f673d96da88814a1a07a57d"
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
