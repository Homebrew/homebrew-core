class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/v1.254.0.tar.gz"
  sha256 "01de3e135645ded97ba5bd901a34926d758f8fb9f6e9e84e2ac03dc3dd8fc9c8"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8668e1450b4b0d2410080808933dd21d4cddec1d562ce081312c39ce8d38773b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a3b05cf28ab4b87f15050dd0412eae82c2afd4f05334459d176182ec03cacd3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cfd718a3c8e9b1eb8ec6230c43d1ef800b43d89bbabd2bf659ec3b91700caa00"
    sha256 cellar: :any_skip_relocation, sonoma:        "f135e5f05101e94f56c5c7e34953e443b8392b990533ebd4d78b714d51d0a2bd"
    sha256 cellar: :any,                 arm64_linux:   "3fa013f39dfcf05e08ca2dc85ed979f2e0fe109f07f620293022e98699d2ef68"
    sha256 cellar: :any,                 x86_64_linux:  "0d015dbc7a5a205e8085d8839411ca691f84cd43ef1d22eadc0d45daebce04eb"
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
