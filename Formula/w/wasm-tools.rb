class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/v1.257.1.tar.gz"
  sha256 "875dfba79df2b09cd4eb6944a75020963a04ec109549de7652e3513971d23971"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b2a444f5d45c0b06f7929301145739b47be8982c9186f5db6b8cd3c1778c5669"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a9ad6c025272f701140d14cad737b9531b9f0751ac8ce4656961a57f40eea2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "118e6ad0860fa9c190dffbf63148ce042f0f83f3996f71bcb58604f7e409fc71"
    sha256 cellar: :any_skip_relocation, sonoma:        "20d2617263d195db94a2c328898e2af4ff3385e73c1e219554abf5440c0d6b22"
    sha256 cellar: :any,                 arm64_linux:   "3c29aec78953f130f9341dfd6a229041dc65f4de24599f34fac1d19f1e997f86"
    sha256 cellar: :any,                 x86_64_linux:  "0d22aab39167a97c1a257b5139a96526e48ae98bbfe8e40361ba791881cabc0a"
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
