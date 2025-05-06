class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/v1.230.0.tar.gz"
  sha256 "4b41dd6228ad9d1643abc07cddb34533f03d285907f2c5f27124804fc3fc715e"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af0dac552c9c4c970a62457018d2ef91cfe540603e7e1f23696e46666201a4b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb198aa667c8e15ba78067938cf009ef8fb5a2cbbbe26f5ba8c0bfde81db7aac"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3e8d6341a63af98ed98539c4a07c3b838d1966a5d9371e73952e124df52f01ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "c2a575d52b32243b187bea904832e843132770186bf5d05ed48ab0c0aac80cf0"
    sha256 cellar: :any_skip_relocation, ventura:       "12f984055fa27a8e386140d4012e3ba2f39195cf549dd081fb8b9b73be901526"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de840542eb3d0e01b1ffef30a66115c067747b924067cda19321f36ccaab83a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8107e1055aa6204377e89367652b1e90efc956c430a1fd0c31dfb0df2ddd6686"
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
