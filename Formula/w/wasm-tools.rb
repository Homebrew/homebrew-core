class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/v1.262.0.tar.gz"
  sha256 "8fafe356b7c63e396d6869c41cb78f76104ae342e1543734f10058d4d5df101c"
  license any_of: [
    { "Apache-2.0" => { with: "LLVM-exception" } },
    "Apache-2.0",
    "MIT",
  ]
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b9ebbb1afed5f434a1d25f9bba68bff34c174587e59a5d1ab7441fb04c26f408"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b8cc132b742c5524e6ed69a53f3587d7d3b250a78494203cfdd4a31003360dba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3c5b9b513ee773919ce4d0e85df9200dc7f7fa43af568139a15873df75f7b058"
    sha256 cellar: :any,                 arm64_linux:       "eca0e71c0f77b50f46cdcb342c25895d105b10a624c7c64d41ee2038981b42b6"
    sha256 cellar: :any,                 x86_64_linux:      "929c9561412099769bd8a5c9805e94b2b6b1084379869b605ef88e58b8be8604"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"wasm-tools", "completion", shells: [:bash, :fish, :pwsh, :zsh])
  end

  test do
    wasm = ["0061736d0100000001070160027f7f017f030201000707010373756d00000a09010700200020016a0b"].pack("H*")
    (testpath/"sum.wasm").write(wasm)
    system bin/"wasm-tools", "validate", testpath/"sum.wasm"

    expected = <<~WASM
      (module
        (type (;0;) (func (param i32 i32) (result i32)))
        (export "sum" (func 0))
        (func (;0;) (type 0) (param i32 i32) (result i32)
          local.get 0
          local.get 1
          i32.add
        )
      )
    WASM
    assert_equal expected, shell_output("#{bin}/wasm-tools print #{testpath}/sum.wasm")
  end
end
