class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/v1.235.0.tar.gz"
  sha256 "babd9a5d3173882997458985842b9d990f31bf5d2871ded0845c2e33bbdc4c93"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e8d31537053efd48ec00e1dd9bd77c888aae8933af51969a20d4980ddd9a0f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0617a49897e6ad127f3312f781088cd759390c4ae074296573772674097a6a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d4a047b94fdb7665a19c3c55ee86754bd6aba5df527bb753a964cbdb5064940b"
    sha256 cellar: :any_skip_relocation, sonoma:        "578ae5744fa0c010739801699e0d11bee8fba94e769e96c330fb43889e29f0cc"
    sha256 cellar: :any_skip_relocation, ventura:       "916cbef17993d1821e9f452f0c9fffabc19bbb4b2f7d11095509031c90f8e8eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48feeb991ad3c6c46c2ba33b7fa3e0d8b8f8cb869469be8180bfabc1ddb35c62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4da0b5920527e8ec4d7e70fc3f8a368ce30c38801a03bc7056e56fc748bd96de"
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
