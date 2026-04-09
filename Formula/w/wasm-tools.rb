class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/v1.246.2.tar.gz"
  sha256 "d5cbfd24286c14817db40a8651771681a9a31a45e3225f9eefa76cfef43489da"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4eb6ad84228426223965983ae46b481582f4d9892a35bf9bab208368c6d35a04"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe5e6754492866f4305237d26815f3a2eeb6da5a7d676303279fe17a8fbaa343"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3520351e359d08e3319ffa086c77c3ca81549882e5d718db304f083b8f0693a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "acc34e65613fcbca1b2ff5cca720fcac26664e0860b4c1d2ec116f97838b153f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c47bfcedc214f559daa401f74d8766484bee32e7d4ab0d87e776248674347500"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c543ebcc9e4c509026cefdf3bd83444e6b906bd5cf066236e1fdd68e2fa2f002"
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
