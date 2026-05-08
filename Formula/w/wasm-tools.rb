class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/v1.248.0.tar.gz"
  sha256 "ad3222fba69e8ea8221e723dc024dee9e0e85aed63b29f1379e1f2e98b6e03cb"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "529ce65931601b571d97edf0fc76dddfa1c99e2466d9acdb47bdc8b3a1df4870"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f43de2ecfd14526c0a030a19dafd570680601817147bc778199ec71a27866d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed7afa08708ab3179d79fae033676ef62caba31632233dfca74a89882efbe5a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "f86e825eef1d402b8b8149e85ec3190f9e41303169793fa51db77847261e057f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "976cfea94f844ddcd5618218a8b28005f5a4a98648269b66cce47297673f4464"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "959ef17f8eea4b126d38c1161c445ed013f3aa525c2d0ddcc0570acb44f0535e"
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
