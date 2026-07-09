class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/v1.253.0.tar.gz"
  sha256 "7518425d04f4f89f49023382aa7019450ff2ac8b1de6b0c3bc5c47ef9b8a0766"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "24cdbfd7583e236ddaedf661d44aa5e96b4f061038396a2de6d8d1a0f32dc152"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21557546e405257e7bebcf53ee84aa68ed39f182826c7f1f3393217f61c46c81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9ac449a86cc1ca3ae7e08e6592bf9f6f103722a65197f63ed9bc84d8e026aab"
    sha256 cellar: :any_skip_relocation, sonoma:        "57b5ba1c47ec5f6d9a1718ec1a97963866417a3daf1e64260e977ae59243a294"
    sha256 cellar: :any,                 arm64_linux:   "eb4b6037741e54affc5b7f5c7724991b9933b6466978a68b8024b7ffcde63368"
    sha256 cellar: :any,                 x86_64_linux:  "84abb69f66d1e44671466b83a743c077f1ace2e2d1e5d5bef31de783581ed2f0"
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
