class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/v1.232.0.tar.gz"
  sha256 "b199f1eb4d66e432d541096c88df40d7264d78318cfd39b68bff792c030a975e"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb1356680ecdd1341126c8f1a9611694fe05713792512e4894b4fb2ddb017cbb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5194232698c5af9c8facc434f6f211d50bab92a8a885287374b154b0200702e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "33f686707a272526c739c3b7052963f5e8aaa792f9b0f4754f7696ac6b3e4a0a"
    sha256 cellar: :any_skip_relocation, sonoma:        "318d1519d6a71696c2864d4bb3e0dc7408d3e46dfd13429abb3c8747cea95959"
    sha256 cellar: :any_skip_relocation, ventura:       "6c84fc1c1f05d9754ca38a72a573dda65fd4c47402cebab6e153902b33493045"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8a89eff7db21cf4a6e9d2c9d1696f74cb56c425ff451a76083ab7af7fc479af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c66ed95ed311ac9e3d599ff91f20d80806be8863f923f9432e102ef9163bd5a3"
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
