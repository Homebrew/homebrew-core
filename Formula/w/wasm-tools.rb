class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/v1.259.0.tar.gz"
  sha256 "c3ee7f0757d1220bd4b46260c4fad4549ceea211f91d706649c1ba24ca7fdc17"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6568a78ca72b9c983973250bf249714da22d886e5b78910919c7c75f12d4a9bf"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "793aa16b013417465a4e463054fdaa810050b477c6b3e23bfc4158359c3f3028"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a0b52727a58c491fc116ecee8c3d3feb2904fdd3b309bac7641c8d79d3729ec9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "f30e43f626c4feb07c91da6458d82adaad3bc3700c1fc1b543628872a387c86a"
    sha256 cellar: :any,                 arm64_linux:       "c7dc84f1ed3db946f4ae1ef9d2a799e08a3040278aab9c4dc0842cdc0e4d6ec0"
    sha256 cellar: :any,                 x86_64_linux:      "21575b67bed36f24015f5fa28ba65c1cfba4294c49206b79f3f4baf7ab1889f4"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
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
