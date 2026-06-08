class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/v1.251.0.tar.gz"
  sha256 "111f529d3cb72d378cd7c162e3e707997c53275ac9abd3b355dbd518f3905bff"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e0c1efd3ff4066a15686add97ac675bd96c85eb9af679e5783fcd2b9a76d0f0d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b881b185b8002499514f1ce53a25a1b8781490e09e880c38a1ac7a9d0e378317"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f928865f5d99acc26fbdb2dc6f5f4c24daf4f76b4d94b3612e52566e76e9492c"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee76d4b6257474e4da10f16ce0ab2679c0f3de743fb26ccbda7a57fd865e4fbc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5a5ca5679d277f3c20f2b30ab527db2d7883ef5664f644096e86e2a70554db7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32021fabb807f775754507682da935e3849691698a52764f3f82c58c1bd77098"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"wasm-tools", "completion", shells: [:bash, :fish, :pwsh, :zsh])
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
