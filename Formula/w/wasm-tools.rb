class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/wasm-tools-1.0.45.tar.gz"
  sha256 "11fbf1030307bd70ea136f728c006fe3694227a58781becf64ee7f7151b97540"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^wasm-tools[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9b399a7de128260c16a6768acd789f5e589dfd10e974bd3bf06119cfbfa7676a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ea6449560ba7efcb605b8c8813a29df6c03614423573389aa102437f5e7bd148"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0309dfbacf69616e8b9021e4b3a22457c94f444d1545147e4f528be5c6623bc4"
    sha256 cellar: :any_skip_relocation, sonoma:         "78ee1e96b6c871f2e61961cbbbb0ddf5edaba90b04e6f4ded90c84e74d1b7173"
    sha256 cellar: :any_skip_relocation, ventura:        "4edd3fc682175b8ebedb3035892f50ac3183abf49e32f998b246ac27eed74ee2"
    sha256 cellar: :any_skip_relocation, monterey:       "ca15c24a4f9efb270d7b45e4e1128e2cc411e3fa95ccf2cb4f1cda27e7a0fa0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e80808e440be9fa6a82ec6301ca417105ca063f51102bb6d1a11bcc17f2cf0d"
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
